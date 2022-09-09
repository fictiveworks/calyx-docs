$LOAD_PATH.unshift File.expand_path('./lib', __dir__)

require "components/example_console"

path = "design/mockups/demo.md"
contents = File.read(path)

document = Kramdown::CustomDocument.new(contents, {
  input: "GFM",
  syntax_highlighter: "rouge"
})

# def to_js
#   bundle = ["const EXAMPLE_HANDLERS = {}"]
#
#   @custom_elements.each do |element|
#     bundle << element.to_js
#     bundle << "EXAMPLE_HANDLERS[\"#{element.id}\"] = #{element.name}"
#   end
#
#   bundle.join("\n\n")
# end

bundle_content = <<-BUNDLE
import calyx from "calyx";

#{document.custom_elements.map(&:to_js).join("\n\n")}

const exampleHandlers = {
  #{document.custom_elements.map(&:name).join(", ")}
};

document.addEventListener("example-console:run", (ev) => {
  const result = exampleHandlers[ev.detail.name]();
  ev.detail.run(result);
})
BUNDLE

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
  <script type="module" src="./ui/components.js"></script>
  <script type="module">
  #{bundle_content}
  </script>
</body>
</html>
TPL

File.write("www/demo.html", template_content)
File.write("src/demo.js", bundle_content)
