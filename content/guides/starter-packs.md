---
title: Starter Packs
---

To work in your browser without installing anything, we recommend remixing one of our JavaScript starter packs on Glitch.

## Generative Writing Starter

<div class="glitch-embed-wrap" style="height: 420px; width: 100%;">
  <iframe
    src="https://glitch.com/embed/#!/embed/calyx-generative-writing-starter?path=script.js&previewSize=100"
    title="calyx-generative-writing-starter on Glitch"
    allow="geolocation; microphone; camera; midi; encrypted-media; xr-spatial-tracking; fullscreen"
    allowFullScreen
    style="height: 100%; width: 100%; border: 0;">
  </iframe>
</div>

<a href="https://glitch.com/edit/#!/remix/calyx-generative-writing-starter"><img alt="Remix on Glitch" src="https://cdn.gomix.com/f3620a78-0ad3-4f81-a271-c8a4faa20f86%2Fremix-button.svg"></a>

Demonstrates how to use the basic features of Calyx to generate a story logline.

This grammar encodes a wide range of possible scenarios within the same basic sentence template: “When *protagonist* makes *inciting discovery*, they face *central adversity*.”

Features used:

- [Uniform branches](/guides/uniform-branches.html) to expand the starting sentence template
- [Memo expansions](/guides/memo-expansions.html) to keep the same pronoun in different parts of the sentence
- [Cycle expansions](/guides/cycle-expansions.html) to avoid repeating the same adjective in different parts of the sentence

## Generative Art Starter

<div class="glitch-embed-wrap" style="height: 500px; width: 100%;">
  <iframe
    src="https://glitch.com/embed/#!/embed/calyx-generative-art-starter?path=style.css&previewSize=100"
    title="calyx-generative-art-starter on Glitch"
    allow="geolocation; microphone; camera; midi; encrypted-media; xr-spatial-tracking; fullscreen"
    allowFullScreen
    style="height: 100%; width: 100%; border: 0;">
  </iframe>
</div>

<a href="https://glitch.com/edit/#!/remix/calyx-generative-art-starter"><img alt="Remix on Glitch" src="https://cdn.gomix.com/f3620a78-0ad3-4f81-a271-c8a4faa20f86%2Fremix-button.svg"></a>

Demonstrates how Calyx can be used to generate SVG images by feeding the results of one grammar into another.

The image generator constructs a circle filled with a linear gradient that has varying bands and varying colours, based on different types of atmospheres found on gas giant planets.

Features used:

- [Uniform branches](/guides/uniform-branches.html), the basic building blocks of all Calyx grammars
- [Context rules] constructed using string interpolation to select which type of planet to generate
- [Memo expansions](/guides/memo-expansions.html) to symmetrically repeat the same colours above and below the equator
