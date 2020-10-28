## Generalizing Context-free Grammars

Theoretical positioning and explanation.

Chomsky hierarchy is focused on recognizers and production systems.

- Regular (Finite state automaton)
- Context-free (Non-deterministic pushdown automaton)
- Context-sensitive (Linear bounded automaton)
- Recursively enumerable (Turing machine)

Computational hierarchy of template expansion systems.

See Horswill, 2020

## Agreement Sketch

```ruby
grammar = Calyx::Grammar.new do
  start "The {noun} {verb} {noun}."
  noun "cat", "dog"
  verb "chases", "licks", "bites"
end

grammar = Calyx::Grammar.new do
  start "The {animal} {verb} {possessive} {appendage}."
  animal "cat", "dog"
  verb "chases", "licks", "bites"
  possessive "her", "his", "its"
  appendage "tail", "paw"
end

grammar = Calyx::Grammar.new do
  start "{@animal} {@verb} {possessive:@animal} {appendage:@verb}."
  animal "Garfield", "Hobbes", "Lady"
  verb "chases", "licks", "chews"
  possessive {
    "Garfield" => "his",
    "Hobbes" => "his",
    "Lady" => "her"
  }
  appendage {
    "chases" => "tail",
    "licks" => "paw",
    "bites" => "leg", "paw"
  }
end
```
