---
title: Calyx
---

This is the intro.

```ruby
grammar = Calyx::Grammar.new do
  start "{greeting} {world}{punkt}"
  greeting "Hello", "Hola", "Hej", "Hallo"
  world "world", "Welt", "Wald", "mundo" "verden"
  punkt ".", "!", "?"
end
```
