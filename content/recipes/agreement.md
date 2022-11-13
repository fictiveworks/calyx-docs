---
title: Agreement
---

Grammatical agreement has a tendency to confound automated text generation. There are sometimes extra steps required to get all parts of a sentence to agree.

Here, we’ll explore different ways to generate English sentences using Calyx by handling the assiduous work of correctly matching varying sets of nouns and verbs to expected gramatical categories.

## What is gramatical agreement?

English is not the most complicated language when it comes to inflection and declension patterns but it does have several categories we have to pay close attention to in writing.

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

## Working from examples

We don’t often need to think about these categories consciously when we’re writing. We know what sounds right. But we sometimes need to think about this connective tissue when we build up word and phrase lists for generating sentences and want to avoid undeliberated juxtapositions that break grammatical rules.

A little bit of planning goes a long way here, especially on larger projects. Sketching out examples of the desired textures and phrase structures to generate makes it easier to write new fragments that snaplock into whole sentences and scan well at a glance.

## Context-free expansion

Expanding a context-free grammar gives a result where none of the chosen parts have any relationship to one another.

In following example, we pick from a list of nouns *Snowball*, *Santa’s Little Helper* and a list of verbs *chases*, *licks*, *bites* which are selected independently when the grammar runs.

<example-console id="context-free-expansion">

```ruby
require "calyx"

pet_sentence = Calyx::Grammar.new do
  start "{animal} {verb}."
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
end

pet_sentence.generate
```

```javascript
import { grammar } from "calyx"

const petSentence = calyx.grammar({
  start: "{animal} {verb}.",
  animal: ["Snowball", "Santa’s Little Helper"],
  verb: ["chases", "licks", "bites"]
})

petSentence.generate()
```

```cs
Grammar petSentence = new Grammar(R => {
  R.Start("{animal} {verb}.");
  R.Rule("animal", new[] { "Snowball", "Santa’s Little Helper" });
  R.Rule("verb", new[] { "chases", "licks", "bites" });
});

petSentence.Generate();
```

</example-console>

We can rewrite this generator to a subject–verb–object form that incorporates a posessive but this will only work if all choices can be random and don’t need to agree with the subject of the sentence.

<example-console id="subject-verb-object">

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

```cs
Grammar catAndMouse = new Grammar(R => {
  R.Start("{animal} {verb} {possessive} {appendage}.");
  R.Rule("animal", new[] { "Snowball", "Santa’s Little Helper" });
  R.Rule("verb", new[] { "chases", "licks", "bites" });
  R.Rule("possessive", new[] { "her", "his", "its" });
  R.Rule("appendage", new[] { "tail", "paw" });
});

catAndMouse.Generate();
```

</example-console>

Here, we expect Snowball to always be matched with feminine inflections and Santa’s Little Helper to be matched with masculine inflections but that isn’t what we get. Each time we expand to a result, a different inflection will be assigned.

## Crafting consistent branches

The first thing we can do is try to break up the sentence into fragments that contain enough bridging context for each result to agree consistently. This usually means splitting off into separate branches for each subject so that all subsequent expansions within that branch are consistent.

<example-console id="branch-fragments">

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

```javascript
import { grammar } from "calyx";

const catAndMouse = grammar({
  start: ["Snowball {verb} her {appendage}",
          "Santa’s Little Helper {verb} his {appendage}"],
  verb: ["chases", "licks", "bites"],
  appendage: ["tail", "paw"]
})

catAndMouse.generate()
```

</example-console>

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
  appendage: ["tail", "paw"]
})

catNMouse.generate()
```

Now we’ve rewritten the grammar with separate masculine and feminine branches that draw from different sets of productions. It’s more flexible and easier to update the lists of nouns but the trade-off stands out at a glance: our new grammar is much more intricate and abstract.

It’s more difficult to read and places a lot more emphasis on precise naming of things, often a source of decision fatigue and disagreement on software projects. Taking this further would mean going down the path of symbolically encoding rules of English grammar in fragments that aren’t reusable outside this one specific example.

Despite these drawbacks, there are situations where this kind of branching is a good pattern to use. Consider this approach with the following circumstances:

- When you have a small set of crafted sentence templates to combine with a large corpus of verbs or nouns
- When you want to export grammars for remixing and combining in other projects

## Modifiers as an escape hatch

If we want to avoid repetitive branching, we need to go beyond the constraints of context-free expansion.

An alternative to crafting agreement and inflection rules into the structure of the grammar is to extend the expression syntax with custom modifier functions and manually handle the string transformations in code to get the desired result.

Prefixing an expression with the `@` sigil allows multiple references in the grammar to point to the same choice rather than picking a different branch each time, which is how we get consistent agreement between the names and posessives.

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

Calyx::Grammar.register_modifiers(PosessiveNouns)

cat_n_mouse = Calyx::Grammar.new do
  start "{@animal} {verb} {@animal.posessive} {appendage}"
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end
```

```js
import { registerModifier, grammar } from "calyx";

function posessive(noun) {
  switch(noun) {
    case "Snowball": return "her"
    case "Santa’s Little Helper": return "his"
    default: return "their"
  }
}

registerModifiers({posessive})

calyx.grammar({
  start: "{@animal} {verb} {@animal.posessive} {appendage}",
  animal: ["Snowball", "Santa’s Little Helper"],
  verb: ["chases", "licks", "bites"],
  appendage: ["tail", "paw"]
})

calyx.generate()
```

People will have different opinions on the trade-off of simplicity and indirection here. The grammar itself is compact and readable but relies on special-case string modifiers which can’t be exported to JSON or embedded in cross-platform environments.

Consider this pattern:

- When your project is self-contained and you don’t plan to export to other engines
- When you want to use 3rd party linguistics or formatting APIs (links to recommended libraries here soon)

## Look it up in the dictionary

Handling this mapping from one to the other is a recurring problem when making large grammars, so Calyx provides a shortcut for adding paired lookups in the grammar directly.

Here, the `{@animal>posessive}` shortcut inflects the output of the memoized `animal` rule using the lookup table declared in `posessive`.

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

Using Calyx’s syntax features like this results in a more abstract and compact grammar, with the tradeoff of having to get used to the custom syntax for map lookups.
