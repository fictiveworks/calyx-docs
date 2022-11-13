import calyx from "calyx";

function context_free_expansion(action) {
  import { grammar } from "calyx"
  
  const petSentence = calyx.grammar({
    start: "{animal} {verb}.",
    animal: ["Snowball", "Santa’s Little Helper"],
    verb: ["chases", "licks", "bites"]
  })
  
  return petSentence.generate()
}

function subject–verb–object(action) {
  import { grammar } from "calyx";
  
  const catAndMouse = grammar({
    start: "{animal} {verb} {possessive} {appendage}.",
    animal: ["Snowball", "Santa’s Little Helper"],
    verb: ["chases", "licks", "bites"],
    possessive: ["her", "his", "its"],
    appendage: ["tail", "paw"]
  })
  
  return catAndMouse.generate()
}

function branch_fragments(action) {
  import { grammar } from "calyx";
  
  const catAndMouse = grammar({
    start: ["Snowball {verb} her {appendage}",
            "Santa’s Little Helper {verb} his {appendage}"]
    verb: ["chases", "licks", "bites"],
    appendage: ["tail", "paw"]
  })
  
  return catAndMouse.generate()
}

const exampleHandlers = {
  context_free_expansion, subject–verb–object, branch_fragments
};

document.addEventListener("example-console:run", (ev) => {
  const result = exampleHandlers[ev.detail.name]();
  ev.detail.run(result);
})
