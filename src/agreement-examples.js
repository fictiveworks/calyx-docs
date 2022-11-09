import calyx from "calyx";

function context_free_expansion(action) {
  const g = calyx.grammar({
    start: "{animal} {verb}.",
    animal: ["Snowball", "Santa’s Little Helper"],
    verb: ["chases", "licks", "bites"]
  })
  
  return g.generate()
}

const exampleHandlers = {
  context_free_expansion
};

document.addEventListener("example-console:run", (ev) => {
  const result = exampleHandlers[ev.detail.name]();
  ev.detail.run(result);
})
