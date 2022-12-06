class NonTerminal {
  constructor(symbol, registry) {
    this.symbol = symbol;
    this.registry = registry;
  }

  evaluate() {
    return [Symbol.for(this.symbol), this.registry.expand(this.symbol).evaluate()]
  }
}

function nonTerminal(symbol, registry) {
  return new NonTerminal(symbol, registry)
}

class Terminal {
  constructor(atom) {
    this.atom = atom;
  }

  evaluate() {
    return [Symbol.for('atom'), this.atom]
  }
}

function terminal(production) {
  return new Terminal(production)
}

const flattenTree = tree => flattenTreeTail(tree).filter(discardSymbols);

const flattenTreeTail = tree => tree.reduce(
  (list, node) => list.concat(Array.isArray(node) ? flattenTree(node) : node),
  []
);

const discardSymbols = entry => typeof entry != "symbol";

class Expression {
  constructor(production, funcs, registry) {
    this.production = production;
    this.funcs = funcs;
    this.registry = registry;
  }

  evaluate() {
    const expansion = flattenTree(this.production.evaluate()).join('');
    const result = this.funcs.reduce((value, func) => this.registry.transform(func, value), expansion);
    return [Symbol.for("expression"), result]
  }
}

function expression(production, funcs, registry) {
  return new Expression(production, funcs, registry)
}

class Memo {
  constructor(symbol, registry) {
    this.symbol = symbol;
    this.registry = registry;
  }

  evaluate() {
    return [Symbol.for(this.symbol), this.registry.evaluateMemo(this.symbol)]
  }
}

function memo(symbol, registry) {
  return new Memo(symbol, registry)
}

class Unique {
  constructor(symbol, registry) {
    this.symbol = symbol;
    this.registry = registry;
  }

  evaluate() {
    return [Symbol.for(this.symbol), this.registry.evaluateUnique(this.symbol)]
  }
}

function unique(symbol, registry) {
  return new Unique(symbol, registry)
}

class Concat {
  constructor(expansion) {
    this.expansion = expansion;
  }

  evaluate() {
    const concat = this.expansion.reduce((accumulator, production) => {
      accumulator.push(production.evaluate());
      return accumulator
    }, []);

    return [Symbol.for('concat'), concat]
  }
}

const EXPRESSION_PATTERN = /(\{[A-Za-z0-9_@$\.]+\})/;
const START_TOKEN = '{';
const END_TOKEN = '}';
const DEREF_TOKEN = '.';
const MEMO_SIGIL = '@';
const UNIQUE_SIGIL = '$';

function concat(production, registry) {
  const expansion = production.split(EXPRESSION_PATTERN).map((fragment) => {
    if (fragment[0] == START_TOKEN && fragment[fragment.length-1] == END_TOKEN) {
      const expr = fragment.slice(1, fragment.length-1).split(DEREF_TOKEN);
      let rule;

      if (expr[0][0] == MEMO_SIGIL) {
        rule = memo(expr[0].slice(1, fragment.length-1), registry);
      } else if (expr[0][0] == UNIQUE_SIGIL) {
        rule = unique(expr[0].slice(1, fragment.length-1), registry);
      } else {
        rule = nonTerminal(expr[0], registry);
      }

      if (expr.length > 1) {
        return expression(rule, expr, registry)
      } else {
        return rule
      }

    } else {
      return terminal(fragment)
    }
  });

  return new Concat(expansion)
}

class Choices {
  constructor(collection) {
    this.collection = collection;
  }

  get length() {
    return this.collection.length
  }

  evaluate() {
    const element = this.collection[Math.floor(Math.random() * this.collection.length)];
    return [Symbol.for('choice'), element.evaluate()]
  }
}

function choices(production, registry) {
  const productions = (typeof production == 'string') ? [production] : production;

  const choices = productions.map((choice) => {
    if (typeof choice == 'string') {
      return concat(choice, registry)
    }
  });

  return new Choices(choices)
}

class WeightedChoices {
  constructor(productions, weights, rng) {
    this.productions = productions;
    this.weights = weights;
    this.rng = rng;
  }

  get length() {
    return this.productions.length
  }

  evaluate() {
    let maxIndex = 0;
    let maxRoll = 0;

    for (let i=0; i<this.weights.length; i++) {
      let currentWeight = this.weights[i];
      let currentRoll =  Math.pow(this.rng(), 1.0 / currentWeight);

      if (currentRoll > maxRoll) {
        maxRoll = currentRoll;
        maxIndex = i;
      }
    }

    return [Symbol.for("weighted_choice"), this.productions[maxIndex].evaluate()]
  }
}

function weightedChoices(rules, rng) {
  const productions = Object.keys(rules).map((rule) => concat(rule));
  const weights = Object.values(rules);
  const weightsTotal = weights.reduce((a,b) => a + b);

  let normalizedWeights;

  if (Number.isInteger(weights[0])) {
    normalizedWeights = weights.map((weight) => (weight / weightsTotal * 1.0));
  } else {
    if (weightsTotal != 1) throw Error("Weights must sum to 1")
    normalizedWeights = weights;
  }

  return new WeightedChoices(productions, normalizedWeights, rng)
}

function rule(name, production, registry) {
  if (production.length == undefined) {
    return new Rule(name, weightedChoices(production, registry))
  } else {
    return new Rule(name, choices(production, registry))
  }
}

class Rule {
  constructor(name, production) {
    this.name = name;
    this.production = production;
  }

  get length() {
    return this.production.length
  }

  evaluate() {
    return this.production.evaluate()
  }
}

class Registry {
  constructor(rules={}) {
    this.rules = {};
    this.memos = {};
    this.uniques = {};
    this.context = {};

    for (const key in rules) {
      this.rules[key] = rule(key, rules[key], this);
    }
  }

  reset() {
    this.memos = {};
    this.uniques = {};
    this.context = {};
  }

  combine(registry) {
    this.rules = Object.assign(this.rules, registry.rules);
  }

  transform(name, value) {
    return (value[name]) ? value[name]() : value
  }

  expand(symbol) {
    const expansion = this.rules[symbol] || this.context[symbol];

    if (!expansion) throw new Error(`UndefinedRule: ${symbol}`)

    return expansion
  }

  evaluateMemo(symbol) {
    if (!this.memos[symbol]) this.memos[symbol] = this.expand(symbol).evaluate();
    return this.memos[symbol]
  }

  evaluateUnique(symbol) {
    let pending = true;
    let result;
    if (!this.uniques[symbol]) this.uniques[symbol] = [];

    while (pending) {
      if (this.uniques[symbol].length == this.rules[symbol].length) {
        this.uniques[symbol] = [];
        pending = false;
      }

      result = this.expand(symbol).evaluate();

      if (!this.uniques[symbol].includes(JSON.stringify(result))) {
        this.uniques[symbol].push(JSON.stringify(result));
        pending = false;
      }
    }

    return result
  }

  evaluate(symbol="start", context={}) {
    this.reset();

    for (const key in context) {
      if (this.rules[key]) {
        throw new Error(`DuplicateRule: ${key}`)
      }

      this.context[key] = rule(key, context[key], this);
    }

    return [Symbol.for(symbol), this.expand(symbol).evaluate()]
  }
}

class Result {
  constructor(expression) {
    this.expression = Object.freeze(expression);
  }

  get tree() {
    return this.expression
  }

  get text() {
    return this.toString()
  }

  toString() {
    return flattenTree(this.expression).join('')
  }
}

function result(expression) {
  return new Result(expression)
}

const mapDefaultArgs = (args) => {
  let symbol = "start";
  let context = {};

  args.forEach((arg) => {
    if (!arg) return

    if (typeof arg == 'string') {
      symbol = arg;
    } else if (Object.getPrototypeOf(arg) === Object.prototype) {
      context = arg;
    }
  });

  return {
    symbol,
    context
  }
};

const grammar = (rules) => {
  const registry = new Registry(rules);

  const instance = (_rules) => {
    return grammar(Object.assign(rules, _rules))
  };

  instance.generate = (symbolOpt, contextOpt) => {
    const { symbol, context } = mapDefaultArgs([symbolOpt, contextOpt]);
    return result(registry.evaluate(symbol, context))
  };

  return instance
};

var calyx = {
  grammar
};

var calyx_1 = calyx;

export default calyx_1;
