import calyx from "calyx";

function context_free_expansion(action) {
  
  const pets = calyx.grammar({
    start: "{animal} {verb}.",
    animal: ["Snowball", "Santa’s Little Helper"],
    verb: ["chases", "licks", "bites"]
  })
  
  return pets.generate()
}

function subject_verb_object(action) {
  
  const pets = grammar({
    start: "{animal} {verb} {possessive} {appendage}.",
    animal: ["Snowball", "Santa’s Little Helper"],
    verb: ["chases", "licks", "bites"],
    possessive: ["her", "his", "its"],
    appendage: ["tail", "paw"]
  })
  
  return pets.generate()
}

function branch_fragments(action) {
  
  const pets = grammar({
    start: ["Snowball {verb} her {appendage}",
            "Santa’s Little Helper {verb} his {appendage}"],
    verb: ["chases", "licks", "bites"],
    appendage: ["tail", "paw"]
  })
  
  return pets.generate()
}

const exampleHandlers = {
  context_free_expansion, subject_verb_object, branch_fragments
};

document.addEventListener("example-console:run", (ev) => {
  const result = exampleHandlers[ev.detail.name]();
  ev.detail.run(result);
})
