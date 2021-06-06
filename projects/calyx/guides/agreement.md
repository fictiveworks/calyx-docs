# Agreement

In this lesson, we will look at how different features of Calyx support adaptive and flexible generation of sentences from varying sets of nouns and verbs that can handle the assiduous work of correctly matching each part to an expected gramatical category.

Grammatical agreement has a tendency to confound automated text generation and there are sometimes extra steps required to get all parts of a sentence to agree.

## What is gramatical agreement?

English is not a hugely complicated language when it comes to inflection and declension patterns but it does have several categories we have to pay attention to.

## Person

When the subject of a sentence varies by person, the verb must follow:

- I am
- You are
- He/She is
- They are

## Gender

When the antecedent of a sentence has a defined or implied gender, any following pronouns must match that gender:

- Michael reviews her data (she has a lot)
- Stamets reviews his data (he has a lot)
- Adira reviews their data (they have a lot)
- The Sphere reviews its data (it has a lot)

## Number

When the subject of a sentence varies between singular and plural forms, the verb must agree:

- The person sings
- The people sing

Pronouns and posessives must also match the singular or plural form of their antecedent:

- The girl raises her arm
- The girls raise their arms

Determiners also have their own specific singular and plural forms:

- That robot
- Those robots

We don’t need to think about these categories consciously when we’re writing. We know what sounds right. But we do need to think about this connective tissue when we build up word and phrase lists for a grammar.

Doing a bit of planning, sketching out the texture and the designed structure of what you want to generate, paying attention to the detail of of embedding key words in multiple places in the text is well worth doing on larger projects. Having a good understanding off all this makes it easier to quickly write fragments that snaplock into whole sentences, avoiding undeliberated juxtapositions that don’t scan well at a glance.

## Context-free expansion

Expanding a context-free grammar gives a result where none of the chosen parts have any relationship to one another.

In following example, we pick from a list of nouns (Snowball, Santa’s Little Helper) and a list of verbs (chases, licks, bites) which are entirely independent.

<example-console id="context-free-expansion">

<example-code markdown="block" label="ruby" tab="ruby" selected="true">
```ruby
g = Calyx::Grammar.new do
  start "{animal} {verb}."
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
end

g.generate
```
</example-code>

<example-code markdown="block" label="javascript" tab="javascript" selected="false" runnable>
```javascript
const g = calyx.grammar({
  start: "{animal} {verb}.",
  animal: ["Snowball", "Santa’s Little Helper"],
  verb: ["chases", "licks", "bites"]
})

g.generate()
```
</example-code>

<example-code markdown="block" label="json">
```json
{
  "start": "{animal} {verb}.",
  "animal": ["Snowball", "Santa’s Little Helper"],
  "verb": ["chases", "licks", "bites"]
}
```
</example-code>

</example-console>

```ruby
require "calyx"

grammar = Calyx::Grammar.new do
  start "{animal} {verb}."
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
end

grammar.generate
```

We can rewrite this generator to a subject–verb–object form that incorporates a posessive but this will only work if all choices can be random and don’t need to agree with the subject of the sentence.

```ruby
require "calyx"

cat_n_mouse = Calyx::Grammar.new do
  start "{animal} {verb} {possessive} {appendage}."
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
  possessive "her", "his", "its"
  appendage "tail", "paw"
end

cat_n_mouse.generate
```

```js
import { grammar } from "calyx";

const catAndMouse = grammar({
  start: "{animal} {verb} {possessive} {appendage}.",
  animal: ["Snowball", "Santa’s Little Helper"],
  verb: ["chases", "licks", "bites"],
  possessive: ["her", "his", "its"],
  appendage: ["tail", "paw"]
})

catAndMouse.generate()
```



Here, we expect Snowball to always be matched with feminine inflections and Santa’s Little Helper to be matched with masculine inflections but that isn’t what we get. Each time we expand to a result, a different inflection will be assigned.

## Crafting consistent branches

The first thing we can do is try to break up the sentence into fragments that contain enough bridging context for each result to agree consistently. This usually means splitting off into separate branches for each subject so that all subsequent expansions within that branch are consistent.

```ruby
require "calyx"

cat_n_mouse = Calyx::Grammar.new do
  start "Snowball {verb} her {appendage}",
        "Santa’s Little Helper {verb} his {appendage}"
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end

cat_n_mouse.generate
```

We now have sentences that agree consistently but the trade-off is that the grammar is less flexible and has a lot of duplication. Although there are only two possible subject variations here, in practice we often want to build up these lists of nouns from external data sources or name generators where it’s not viable to carefully craft sentence fragments for each possible variation.

One way to balance keeping the grammar context-free without losing the flexibility of atomic word lists is to carefully separate the sentence fragment branches and gramatical categories into a more intricate set of production rules.

```ruby
cat_n_mouse = Calyx::Grammar.new do
  start "{f_phrase}.", "{m_phrase}."
  f_animal "Snowball"
  f_phrase "{f_animal} {verb} {f_posessive} {appendage}"
  f_posessive "her"
  m_animal "Santa’s Little Helper"
  m_phrase "{m_animal} {verb} {m_posessive} {appendage}"
  m_posessive "his"
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end
```

```js
const catNMouse = grammar({
  start: ["{f_phrase}.", "{m_phrase}."],
  f_animal: "Snowball",
  f_phrase: "{f_animal} {verb} {f_posessive} {appendage}",
  f_posessive: "her",
  m_animal: "Santa’s Little Helper",
  m_phrase: "{m_animal} {verb} {m_posessive} {appendage}",
  m_posessive: "his",
  verb: ["chases", "licks", "bites"],
  appendage ["tail", "paw"]
})

catNMouse.generate()
```

Now we’ve rewritten the grammar with separate masculine and feminine branches that draw from different sets of productions. It’s more flexible and easier to update the lists of nouns but the trade-off is obvious at a glance: the grammar is now much more intricate and abstract.

Not only is it difficult to read, it also places a lot more emphasis on the so-called hardest problem of naming things, often a source of decision fatigue and disagreement. Taking this further would mean going down the path of symbolically encoding rules of English grammar in fragments that aren’t reusable outside any one specific example.

Despite these drawbacks, there are situations where branching is a good pattern to use. Consider this approach under the following circumstances:

- When you have a small and well-defined set of nouns to draw from
- When you have a small set of crafted sentence variations
- When flexibility or adaptability isn’t important
- When you might want to treat the code as data and convert it to other formats in future

## Mappings and Memos

If we want to avoid repetitive branching, we need to go beyond the constraints of context-free expansion.

Mappings allow you to transform strings from one set into strings from another. They are declared as named rules in the grammar but require a rule symbol to be provided as an argument.

Memos are one of the primary features Calyx provides to make this process easier. Prefixing an expression with the `@` sigil allows multiple references in the grammar to point to the same choice rather than picking a different branch each time.

```ruby
grammar = Calyx::Grammar.new do
  filter :posessive do |noun|
    case noun
    when "Santa’s Little Helper" then "his"
    when "Snowball" then "her"
    else
      "their"
    end
  end

  mapping :pronoun, {
    /Snowball/ => "her",
    /Santa/ => "his"
  }

  start "{@animal} {verb} {@animal.posessive} {appendage}"
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end
```

```ruby
grammar = Calyx::Grammar.new do
  start "{@animal} {verb} {@animal} {appendage}"
  animal "Snowball", "Santa’s Little Helper"
  snowball "her"
  rule("Santa’s Little Helper", ["his"])
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end
```

## Inflections with custom modifiers

An alternative to crafting agreement and inflection rules into the structure of the grammar is to extend the expression syntax with custom modifier functions and manually handle the string transformations in code to get your desired result.

```ruby
module PosessiveNouns
  def posessive(noun)
    case noun
    when "Snowball" then "her"
    when "Santa’s Little Helper" then "his"
    else
      "their"
    end
  end
end

Calyx::Grammar.embed_modifiers(PosessiveNouns)

cat_n_mouse = Calyx::Grammar.new do
  start "{@animal} {verb} {@animal.posessive} {appendage}"
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end
```

```js

const posessiveNouns = {
  possessive: noun => {
    switch(noun) {
      case "Snowball": return "her"
      case "Santa’s Little Helper": return "his"
      default: return "their"
    }
  }
}

calyx.embedModifiers(posessiveNouns)

calyx.grammar({
  start: "{@animal} {verb} {@animal.posessive} {appendage}",
  animal: ["Snowball", "Santa’s Little Helper"],
  verb: ["chases", "licks", "bites"],
  appendage: ["tail", "paw"]
})

calyx.generate()
```

## Mapping Dictionaries

Because this sort of mapping from one to the other is a fairly common thing to do, Calyx provides a shortcut in the form of map productions that can be applied as a lookup table of modifiers after a generated symbol.

Here, the `{@animal>posessive}` substitution inflects the output of the memoized `animal` rule using the lookup table declared in `posessive`.

```js
calyx.grammar({
  start: "{@animal} {verb} {@animal>posessive} {appendage}",
  animal: ["Snowball", "Santa’s Little Helper"]
  posessive: {
    "Snowball": "her",
    "Santa’s Little Helper": "his"
  },
  verb: ["chases", "licks", "bites"],
  appendage: ["tail", "paw"]
})
```

Map substitutions are bidirectional. The direction of match to target can be changed between left to right and right to left by flipping the `<` and `>` applicators.
