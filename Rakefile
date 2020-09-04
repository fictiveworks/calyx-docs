require "yard"

task :packages do
  sh "git clone https://github.com/maetl/calyx packages/calyx-rb"
  sh "git clone https://github.com/fictiveworks/calyx packages/calyx-js"
  sh "git clone https://github.com/maetl/mementus packages/mementus-rb"
  sh "git clone https://github.com/fictiveworks/mementus packages/mementus-js"
end

YARD::Templates::Engine.register_template_path("templates/yard")

YARD::Rake::YardocTask.new do |t|
  t.name = :calyx_api_rb
  t.opts = ["--output-dir api", "--title 'Calyx API'"]
  t.files = ["packages/calyx-rb/lib/**/*.rb"]
end

YARD::Rake::YardocTask.new do |t|
  t.name = :mementus_api_rb
  t.files = ["packages/mementus-rb/lib/**/*.rb"]
end

task :calyx_api_js do
  sh "npm run build:calyx"
end

task :mementus_api_js do
  sh "npm run build:mementus"
end

task :api_rb => [:calyx_api_rb, :mementus_api_rb]
task :api_js => [:calyx_api_js, :mementus_api_js]
task :api => [:api_rb, :api_js]

task :styles do

end
