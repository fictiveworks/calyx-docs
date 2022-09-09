import { html, render, nothing } from "lit-html";
import { component, useState, useReducer, useEffect } from "haunted";

function CopyIcon() {
  return html`
    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect>
      <path d="M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"></path>
      <path d="M16 4h2a2 2 0 0 1 2 2v4"></path>
      <path d="M21 14H11"></path>
      <path d="m15 10-4 4 4 4"></path>
    </svg>
  `;
}

function RepeatIcon() {
  return html`
    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <rect x="2" y="10" width="12" height="12" rx="2" ry="2"></rect>
      <path d="m17.92 14 3.5-3.5a2.24 2.24 0 0 0 0-3l-5-4.92a2.24 2.24 0 0 0-3 0L10 6"></path>
      <path d="M6 18h.01"></path>
      <path d="M10 14h.01"></path>
      <path d="M15 6h.01"></path>
      <path d="M18 9h.01"></path>
    </svg>
  `;
}

function ResetIcon() {
  return html`
    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M21 2v6h-6"></path>
      <path d="M3 12a9 9 0 0 1 15-6.7L21 8"></path>
      <path d="M3 22v-6h6"></path>
      <path d="M21 12a9 9 0 0 1-15 6.7L3 16"></path>
    </svg>
  `;
}

function ExampleReady(runExample) {
  return html`<div class="example-ready">
    <button class="example-run" @click=${runExample}>
      <svg version="1.1" id="run-id" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" height="100px" width="100px"
         viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
        <path class="stroke-solid" fill="none" stroke="white"  d="M49.9,2.5C23.6,2.8,2.1,24.4,2.5,50.4C2.9,76.5,24.7,98,50.3,97.5c26.4-0.6,47.4-21.8,47.2-47.7
          C97.3,23.7,75.7,2.3,49.9,2.5"/>
        <path class="icon" fill="white" d="M38,69c-1,0.5-1.8,0-1.8-1.1V32.1c0-1.1,0.8-1.6,1.8-1.1l34,18c1,0.5,1,1.4,0,1.9L38,69z"/>
      </svg>
    </button>
  </div>`;
}

const ResultView = {
  STRING: "string",
  INSPECT: "inspect"
}

// const ExampleResult = virtual((state) => {
//   console.log("From child")
//   console.log(state)
//
//   // const markup = (state.mode == ResultView.STRING)
//   //   ? html`<p class="example-text">${state.result.text}</p>`
//   //   : html`<div class="example-inspector">${ExampleInspector(state.result)}</div>`;
//   //
//   // return html`<div class="example-result">
//   //   ${markup}
//   // </div>`;
//
//   return html`<div class="example-result">
//     Static text
//   </div>`;
// });

const initialState = {
  isReady: true,
  result: null,
  mode: ResultView.STRING
}

function outputReducer(state, action) {
  switch (action.type) {
    case "run":
      return { isReady: false, result: action.result, mode: state.mode };
    case "mode":
      return { isReady: false, result: state.result, mode: action.mode }
    case "reset":
      return initialState;
  }
}

function ExampleInspector(result) {
  //const nodes = Array.isArray(result) ?

  return html`
    <ul class="example-object">
      <li>-> Result(${result.text})

      </li>
    </ul>
  `;
}

function ExampleRun(state) {
  const markup = (state.mode == ResultView.STRING)
    ? html`<p class="example-text">${state.result.text}</p>`
    : html`<div class="example-inspector">${ExampleInspector(state.result)}</div>`;

  return html`<div class="example-result">
    ${markup}
  </div>`;
}

function ExampleConsole({ name }) {
  const [state, dispatch] = useReducer(outputReducer, initialState);
  const [selectedTab, setSelectedTab] = useState(null);
  const tabs = [];

  useEffect(() => {
    const currentScript = this.querySelector("example-script[selected]");

    if (!selectedTab) {
      setSelectedTab(currentScript.getAttribute("label"))
    } else {
      currentScript.style.display = "none";
      currentScript.removeAttribute("selected");

      const nextScript = this.querySelector(`example-script[label='${selectedTab}']`);
      nextScript.style.display = "block";
      nextScript.setAttribute("selected", "true");
    }
  }, [selectedTab]);

  const exampleScripts = Array.from(this.querySelectorAll("example-script"));
  const exampleTabs = exampleScripts.map(el => el.getAttribute("label"));

  const runExample = () => {
    this.dispatchEvent(new CustomEvent("example-console:run", {
      bubbles: true,
      composed: true,
      detail: {
        run: (result) => dispatch({ type: "run", result }),
        name: this.getAttribute("id").replace("-", "_")
      }
    }));
  }

  const resetExample = () => dispatch({ type: "reset" });
  const stringMode = () => dispatch({ type: "mode", mode: "string" });
  const inspectMode = () => dispatch({ type: "mode", mode: "inspect" });

  return html`
  <style>
  .example {
    width: 100%;
    background-color: var(--color-navbar-background);
    display: flex;
    border-radius: 12px;
    box-shadow: 4px 4px 0 #333;
  }

  .example-container {
    width: 60%;
  }

  .example-output {
    width: 40%;
    border-left: 1px dotted var(--color-nav-background-hover);
  }

  .example-header,
  .example-footer {
    background-color: var(--color-nav-background-hover);
  }

  .example-container,
  .example-output {
    display: grid;
    grid-template-rows: 1.6em auto 1.6em;
  }

  .example-header {
    grid-row-start: 1;
  }

  .example-container .example-header {
    border-top-left-radius: 12px;
  }

  .example-output .example-header {
    border-top-right-radius: 12px;
  }

  .example-code,
  .example-result,
  .example-ready {
    grid-row-start: 2;
  }

  .example-footer {
    grid-row-start: 3;
  }

  .example-container .example-footer {
    border-bottom-left-radius: 12px;
  }

  .example-output .example-footer {
    border-bottom-right-radius: 12px;
  }

  .example-tabs {
    list-style-type: none;
    margin: 0 1em;
    padding: 0;
    display: flex;
  }

  .example-tabs li {
    margin: 0;
  }

  .example-tabs li button {
    display: inline-flex;
    align-items: center;
    border: none;
    margin: 0;
    padding: 0 1em;
    height: 1.6em;
    background-color: transparent;
    font-size: 100%;
    font-family: inherit;
    line-height: 1;
  }

  .example-tabs li button[aria-selected] {
    background-color: var(--color-navbar-background);
    color: var(--color-nav-link-default);
  }

  .example-tabs li button:hover {
    background-color: var(--color-navbar-background);
    color: var(--color-nav-link-default);
  }

  .example-output .example-tabs {
    justify-content: flex-end;
  }

  .example-ready {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .example-run {
    border: none;
    background-color: transparent;
  }

  .example-run:hover {
    cursor: pointer;
  }

  .example-run:hover .stroke-solid {
    stroke: #aaa;
  }

  .example-run:hover .icon {
    fill: #bbb;
  }

  .example-text {
    font-size: 1em;
    padding: 1em;
    color: white;
  }

  .stroke-solid {
    stroke-width: 4px;
  }

  .example-tabs li button[role=button]:hover {
    cursor: pointer;
  }

  .example-tabs li button[role=button]:active {
    background-color: var(--color-menu-link-background);
    color: var(--color-navbar-background);
  }
  </style>
  <article class="example">
    <div class="example-container">
      <header class="example-header">
        <ul class="example-tabs">
          ${exampleTabs.map(tab => {
            const selectTab = () => setSelectedTab(tab)
            return html`
              <li><button @click=${selectTab} role="tab" ?aria-selected=${tab == selectedTab}>${tab}</button></li>
            `;
          })}
        </ul>
      </header>
      <slot></slot>
      <footer class="example-footer">
        <ul class="example-tabs">
          <li><button role="button" id="copy-button">${CopyIcon()}&nbsp;Copy</button></li>
        </ul>
      </footer>
    </div>
    <div class="example-output">
      <header class="example-header">
        <ul class="example-tabs">
          ${!state.isReady ?
            html`<li><button role="tab" @click=${stringMode} aria-selected>String</button></li>
                 <li><button role="tab" @click=${inspectMode}>Result</button></li>`
            : nothing}
        </ul>
      </header>
      ${state.isReady ? ExampleReady(runExample) : ExampleRun(state)}
      <footer class="example-footer">
        <ul class="example-tabs">
          ${!state.isReady ?
            html`<li><button role="button" @click=${runExample}>${RepeatIcon()}&nbsp;Repeat</button></li>
                 <li><button role="button" @click=${resetExample}>${ResetIcon()}&nbsp;Reset</button></li>`
            : nothing}
        </ul>
      </footer>
    </div>
  </article>
  `;
}

customElements.define("example-console", component(ExampleConsole, {
  observedAttributes: ["name"],
  useShadowDOM: true
}));

function ExampleScript({ label, selected }) {
  const selectedAttr = selected ? "true" : "false";

  return html`
    <style>
      :host(:not([selected])) {
        display: none;
      }
      .example-code {
        padding: 1em;
        font-size: 1.3em;
      }
    </style>
    <div class="example-code" aria-selected=${selectedAttr}>
      <slot></slot>
    </div>
  `;
}

customElements.define("example-script", component(ExampleScript, {
  observedAttributes: ["label", "selected"]
}));
