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
  <script type="module" src="ui/bundle.js"></script>
</body>
</html>
TPL

File.write("www/demo.html", template_content)

#puts document.to_js
