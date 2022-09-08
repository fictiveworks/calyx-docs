## System requirements

The following prerequisites are needed to install Calyx:

- macOS, Windows, GNU/Linux or Unix
- Ruby 2.3 or above (MRI 2.3+, JRuby 9+, Rubinius 3+)
- RubyGems

Calyx has no external Gem dependencies.

## For command line use

Install the Calyx gem using the [RubyGems](https://rubygems.org) package manager:

```
gem install calyx
```

## Demo Example Test

An example of embedding a separate syntax highlighted code block in a document.


<example-console id="hello-world">

```ruby
hello = Calyx::Grammar.new do
  start "Hello {object}."
  object "world", "universe", "planet"
end

hello.generate
```

```js
const hello = calyx.grammar({
  start: "Hello {object}.",
  object: ["world", "universe", "planet"]
})

hello.generate()
```

```cs
Grammar hello = new Grammar(P => {
  P.Start("Hello {object}");
  P.Rule("object", new[] { "world", "universe", "planet"})
});

hello.Generate();
```

</example-console>

## Another demo example

This time with a different approach to a simple grammar.

<example-console id="person-name">

```javascript
const people = calyx.grammar({
  start: "{firstname} {lastname}",
  firstname: ["Gonzo", "Jbob", "Helga", "Trubia", "Fuschia"],
  lastname: ["Tweed", "Gilberenson", "Fullerine", "Tammwell", "Deltax"]
})

people.generate()
```

</example-console>
