$LOAD_PATH.unshift File.expand_path('./lib', __dir__)

require "yarrow"
require "yard"
require "generator"
require "calyx/docs"

task :fictive do
  fictive_path = "~/Projects/fictive/fictive-editor"
  sh "cd #{fictive_path} && FICTIVE_PROJECT=#{Dir.pwd} npm start"
end

task :packages do
  sh "git clone https://github.com/maetl/calyx packages/calyx-rb"
  sh "git clone https://github.com/fictiveworks/calyx packages/calyx-js"
  sh "git clone https://github.com/maetl/mementus packages/mementus-rb"
  sh "git clone https://github.com/fictiveworks/mementus packages/mementus-js"
end

task :serve do
  sh "yarrow-server"
end

task :sitegen do
  generate_site
  sh "cp -r assets/ docs/assets"
end

YARD::Templates::Engine.register_template_path("templates/yard")

# YARD::Rake::YardocTask.new do |t|
#   t.name = :calyx_api_rb
#   t.opts = ["--output-dir api", "--title 'Calyx API'"]
#   t.files = ["packages/calyx-rb/lib/**/*.rb"]
# end
#
# YARD::Rake::YardocTask.new do |t|
#   t.name = :mementus_api_rb
#   t.files = ["packages/mementus-rb/lib/**/*.rb"]
# end

# :calyx_api_rb
# https://github.com/skatkov/rdoc-markdown

task :calyx_api_js do
  # Convert JSDoc to Markdown
  # npm install --save-dev jsdoc-to-markdown
  sh "npm run build:calyx"
end

task :mementus_api_js do
  sh "npm run build:mementus"
end

task :api_rb => [:calyx_api_rb, :mementus_api_rb]
task :api_js => [:calyx_api_js, :mementus_api_js]
task :api => [:api_rb, :api_js]

task :calyx_ui do
  sh "npm run build:ui"
end

task :calyx_css do
  sh "npm run build"
end

task :build => [:sitegen, :calyx_ui, :calyx_css]
