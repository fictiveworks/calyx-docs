import calyx from "../web_modules/calyx.js";

function hello_world(action) {
  const hello = calyx.grammar({
    start: "Hello {object}.",
    object: ["world", "universe", "planet"]
  })
  
  return hello.generate()
}

function person_name(action) {
  const people = calyx.grammar({
    start: "{firstname} {lastname}",
    firstname: ["Gonzo", "Jbob", "Helga", "Trubia", "Fuschia"],
    lastname: ["Tweed", "Gilberenson", "Fullerine", "Tammwell", "Deltax"]
  })
  
  return people.generate()
}

const exampleHandlers = {
  hello_world, person_name
};

document.addEventListener("example-console:run", (ev) => {
  const result = exampleHandlers[ev.detail.name]();
  ev.detail.run(result);
})
