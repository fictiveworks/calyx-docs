import calyx from "calyx";
import "./components.js"

const EXAMPLE_HANDLERS = {}

function hello_world(action) {
const hello = calyx.grammar({
  start: "Hello {object}.",
  object: ["world", "universe", "closure"]
})

return hello.generate()
}



EXAMPLE_HANDLERS["hello-world"] = hello_world

function person_name(action) {
const people = calyx.grammar({
  start: "{firstname} {lastname}",
  firstname: ["Gonzo", "Jbob", "Helga", "Trubia", "Fuschia"],
  lastname: ["Tweed", "Gilberenson", "Fullerine", "Tammwell", "Deltax"]
})

return people.generate()
}



EXAMPLE_HANDLERS["person-name"] = person_name

document.addEventListener("example-console:run", (ev) => {
  const result = EXAMPLE_HANDLERS[ev.detail.id]();
  ev.detail.run(result);
})
