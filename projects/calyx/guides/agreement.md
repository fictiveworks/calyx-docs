# Agreement

In this guide, we will look at how different features of Calyx support adaptive and flexible generation of sentences from varying sets of nouns and verbs while correctly matching parts of the sentences to the expected gramatical category.

Although English is not hugely complicated when it comes to inflection and declension patterns, there are a moderate number of categories which have specific rules.

## Person

When the subject of a sentence varies by person, the verb must follow:

- I am
- You are
- He/She is
- They are

## Gender

When the antecedent of a sentence has a defined or implied gender, any following pronouns must match that gender:

- Catra raises her arm
- Bow raises his arm
- Double Trouble raises their arm
- A Horde-Bot raises its arm

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

We don’t usually think about these categories consciously when we’re writing as we know what ‘sounds right’ but it’s worth establishing the rules explicitly here because grammatical agreement has a tendency to confound simple methods of text generation using template expansion. There are extra steps required to make sure all parts of a sentence agree.

## Context-free expansion

Expanding a context-free grammar gives a result where none of the chosen parts have any relationship to one another.

In following example, we pick from a list of nouns (Snowball, Santa’s Little Helper) and a list of verbs (chases, licks, bites) which are entirely independent.

```ruby
grammar = Calyx::Grammar.new do
  start "{animal} {verb}."
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
end
```

We can rewrite this generator to a subject–verb–object form that incorporates a posessive but this will only work if all choices can be random and don’t need to agree with the subject of the sentence.

```ruby
grammar = Calyx::Grammar.new do
  start "{animal} {verb} {possessive} {appendage}."
  animal "Snowball", "Santa’s Little Helper"
  verb "chases", "licks", "bites"
  possessive "her", "his", "its"
  appendage "tail", "paw"
end
```

Here, we expect Snowball to always be matched with feminine inflections and Santa’s Little Helper to be matched with masculine inflections but that isn’t what we get. Each time we expand to a result, a different inflection will be assigned.

## Crafting consistent branches

The first thing we can do is try to break up the sentence into fragments that contain enough bridging context for each result to agree consistently. This usually means splitting off into separate branches for each subject so that all subsequent expansions within that branch are consistent.

```ruby
grammar = Calyx::Grammar.new do
  start "Snowball {verb} her {appendage}",
        "Santa’s Little Helper {verb} his {appendage}"
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end
```

We now have sentences that agree consistently but the trade-off is that the grammar is less flexible and has a lot of duplication. Although there are only two possible subject variations here, in practice we often want to build up these lists of nouns from external data sources or name generators where it’s not viable to carefully craft sentence fragments for each possible variation.

One way to balance keeping the grammar context-free without losing the flexibility of atomic word lists is to carefully separate the sentence fragment branches and gramatical categories into a more intricate set of production rules.

```ruby
grammar = Calyx::Grammar.new do
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

Here, we’ve rewritten the grammar with separate masculine and feminine branches that draw from different sets of productions. It’s more flexible and easier to update the lists of nouns but the trade-off is obvious at a glance: the grammar is now much more intricate and abstract.

Not only is it more difficult to read, it also places a lot more emphasis on the so-called hardest problem of naming things, often a source of decision fatigue and disagreement. We’re going down the path of symbolically encoding rules of English grammar in fragments that aren’t reusable outside this specific example.

Despite these drawbacks, there are situations where branching is a good pattern to use. Consider this approach under the following circumstances:

- When you have a small and well-defined set of nouns to draw from
- When you have a small set of crafted sentence variations
- When flexibility or adaptability isn’t important
- When you want your generator to be directly transferable to other tools and languages (eg: Tracery)

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
  start "{@animal} {verb} {&@animal} {appendage}"
  animal "Snowball", "Santa’s Little Helper"
  snowball "her"
  rule("Santa’s Little Helper", ["his"])
  verb "chases", "licks", "bites"
  appendage "tail", "paw"
end
```
