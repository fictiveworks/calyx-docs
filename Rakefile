require "yarrow"
require "yard"
require "./generator"

task :dev_server do
  class DevServer < Yarrow::Server
    def config
      Yarrow::Configuration.new(output_dir: "./www", server: {
        port: 4200,
        host: "localhost",
        handler: "webrick"
      })
    end
  end

  server = DevServer.new
  server.run
end

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

task :build do
  generate_site
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

task :calyx_api_js do
  sh "npm run build:calyx"
end

task :mementus_api_js do
  sh "npm run build:mementus"
end

task :api_rb => [:calyx_api_rb, :mementus_api_rb]
task :api_js => [:calyx_api_js, :mementus_api_js]
task :api => [:api_rb, :api_js]

task :calyx_ui do
  sh "npm run build"
end

task :mementus_css do
  sh ""
end

namespace :install do
  task :config do

  end

  task :sites do
    require "tty-prompt"

    prompt = TTY::Prompt.new

    pwdtext = File.basename(File.dirname(__FILE__))
    default_domain = "https://#{pwdtext.downcase}#{[".org", ".website"].sample}"
    default_title = pwdtext.capitalize
    default_name = pwdtext.downcase
    default_author = ENV["USER"]
    # default_source_dir = "#{File.dirname(__FILE__)}/content"
    # default_output_dir = "#{File.dirname(__FILE__)}/web"

    domain = prompt.ask("Domain (public URL)", default: default_domain) do |q|
      q.convert(:uri)
    end
    title = prompt.ask("Title (main h1)", default: default_title)
    name = prompt.ask("Name (short text identifier)", default: default_name)
    author = prompt.ask("Author Name", default: default_author)
    email = prompt.ask("Author Email", default: "webmaster@#{domain.host}")
    # source_dir = prompt.ask("Source Directory", default: default_source_dir)
    # output_dir = prompt.ask("Output Directory", default: default_output_dir)

    #launched_at = prompt.ask("Launched At (documented launch date)")

    Site = Yarrow::Schema::Value.new(:domain, :title, :name, :author, :email)

    site = Site.new(domain, title, name, author, email)

    p site
  end

  task :www do
    sh "mkdir -p www/calyx/ui"
    sh "mkdir -p www/mementus/ui"
  end
end
