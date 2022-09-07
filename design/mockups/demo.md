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
  object "world", "universe", "closure"
end
```

```js
const hello = calyx.grammar({
  start: "Hello {object}.",
  object: ["world", "universe", "closure"]
});
```

</example-console>
