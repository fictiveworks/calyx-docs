---
title: Installation
---

## System requirements

The following prerequisites are needed to install Calyx:

- macOS, Windows, GNU/Linux or Unix
- Ruby 2.3 or above (MRI 2.3+, JRuby 9+, Rubinius 3+)
- RubyGems

Calyx has no external Gem dependencies.

## Multilanguage Install

<example-console id="install-test" hideplayer="true">

<example-script label="RubyGems" selected="true">
gem install calyx
</example-script>

<example-script label="NPM">
npm install calyx
</example-script>

</example-console>

## For command line use

Install the Calyx gem using the [RubyGems](https://rubygems.org) package manager:

```
gem install calyx
```

## For applications

Add the `calyx` dependency to your app’s `Gemfile`:

```ruby
gem 'calyx'
```

Run [Bundler](https://bundler.io/) to install it:

```
bundle install
```

## For local development

To contribute code back to Calyx or fork it in a new direction, clone the repo from GitHub:

```
git clone git@github.com:maetl/calyx
```

You can also download the latest build of the project as a ZIP archive:

```
wget https://github.com/maetl/calyx/archive/master.zip
```

## Installing in a Project

### Package Manager

JavaScript via NPM:

```
npm install calyx
```

Ruby via Rubygems:

```
gem install calyx
```

C# via NuGet:

```
dotnet add package Calyx --version 0.3.0
```

## Manual Installation
