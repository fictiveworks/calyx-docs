---
title: Basic Branching
---

Before getting started, you’ll need to install Calyx and have it available in your local dev environment.

If you’re not sure how to do this yet, there’s more information about setting up your environment and how to download and install the library in the [Getting Started guide](/guides/getting-started.html).

## Hello World

Create a file named `hello.rb` and add the following contents:

```ruby
require "calyx"

hello = Calyx::Grammar.new do
  start "Hello world!"
end
```