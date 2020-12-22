import { ExampleConsole, ExampleCode } from "example-console";

customElements.define("example-console", ExampleConsole);
customElements.define("example-code", ExampleCode);

// class ExampleConsole extends HTMLElement {
//   constructor() {
//     super();
//
//     this.attachShadow({ mode: 'open' });
//
//     this.shadowRoot.innerHTML = `
//       <div class="example-box">
//
//       </div>
//     `;
//   }
// }
