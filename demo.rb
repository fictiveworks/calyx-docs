$LOAD_PATH.unshift File.expand_path('./lib', __dir__)

require "document"

path = "design/mockups/demo.md"
contents = File.read(path)

document = Extensions::Document.new(path, contents)

template_content = <<-TPL
<!doctype html>
<html>
<head>
  <title>Demo</title>
  <link rel="stylesheet" type="text/css" href="ui/calyx.css">
</head>
<body>
  <header><i>Calyx Demo</i></header>
  <hr>
  <article>
  #{document.to_html}
  </article>
  <script type="module" src="ui/demo.js"></script>
</body>
</html>
TPL

bundle_content = <<-BUNDLE
import calyx from "calyx";
import "./components.js"

#{document.to_js}

document.addEventListener("example-console:run", (ev) => {
  const result = EXAMPLE_HANDLERS[ev.detail.id]();
  ev.detail.run(result);
})
BUNDLE

File.write("www/demo.html", template_content)
File.write("src/demo.js", bundle_content)

#puts document.to_js
