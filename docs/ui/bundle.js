import calyx from "../web_modules/calyx.js";
import "./components.js"

const hello = calyx.grammar({
  start: "Hello {object}.",
  object: ["world", "universe", "closure"]
});

document.addEventListener("example-console:run", (ev) => {
  if (ev.detail.id =="hello-world") {
    const result = hello.generate();
    ev.detail.run(result);
  }
});
