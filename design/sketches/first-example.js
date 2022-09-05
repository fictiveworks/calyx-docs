function contextfreeexpansion(action) {
const g = calyx.grammar({
  start: "{animal} {verb}.",
  animal: ["Snowball", "Santa’s Little Helper"],
  verb: ["chases", "licks", "bites"]
})

return g.generate()

}
