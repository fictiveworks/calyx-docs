require "kramdown"
require "mustache"
require "fileutils"
require "yarrow"
#require "document"

WEB_DIR = "./www"
CONTENT_DIR = ""
TEMPLATE_DIR = "./templates/yarrow"

DOCUMENT_TPL = "#{TEMPLATE_DIR}/document.html"
INDEX_TPL = "#{TEMPLATE_DIR}/index.html"
HOME_TPL = "#{TEMPLATE_DIR}/homepage.html"

Mustache.template_path = "#{TEMPLATE_DIR}/partials"
Mustache.template_extension = "html"

INDEXES = {}
EXAMPLES = {}

def target_source_path(source_path)
  target_path = source_path.gsub('.md', '.html').gsub("projects/calyx", "calyx")
  "#{WEB_DIR}/#{target_path}"
end

def build_document(source_path)
  doc_title, target_doc = parse_document(source_path)
  target_path = target_source_path(source_path)
  target_dir = File.dirname(target_path)
  FileUtils.mkdir_p(target_dir) unless File.directory?(target_dir)
  File.write(target_path, render_document(doc_title, target_doc))
  append_index(target_path, doc_title)
end

def append_index(path, title)
  dir_key = File.dirname(path)
  INDEXES[dir_key] = [] unless INDEXES.key?(dir_key)
  INDEXES[dir_key] << { title: title, url: target_source_path(path.gsub("#{WEB_DIR}/.", "")) }
end

def write_indexes
  INDEXES.each do |index_dir,listing|
    index_path = "#{index_dir}/index.html"
    index_title = index_dir.gsub("#{WEB_DIR}/./", "").capitalize
    File.write(index_path, render_index(index_title, listing))
  end

  homepage_path = "#{WEB_DIR}/calyx/index.html"
  File.write(homepage_path, Mustache.render(File.read(HOME_TPL)))
end

def parse_document(source_path)
  source = File.read(source_path)
  title = extract_title(source.lines.first)
  parsed_doc = Extensions::Document.new(source_path, source)

  [title, parsed_doc]
end

def extract_title(first_line)
  return "Untitled Document" if first_line.nil? || first_line[0] != '#'
  first_line.split("# ").last
end

def render_document(title, document)
  Mustache.render(File.read(DOCUMENT_TPL), {
    title: title,
    content: document.to_html,
    script: document.to_js
  })
end

def render_index(title, listing)
  Mustache.render(File.read(INDEX_TPL), {title: title, listing: listing})
end

def generate_site_old
  entries = Dir["./projects/calyx/**/*.md"].sort

  entries.each do |path|
    build_document(path)
  end

  write_indexes

  #FileUtils.cp_r(".site/assets", "public")
end

require "yarrow"

def generate_site
  config = Yarrow::Configuration.load("Yarrowdoc")
  generator = Yarrow::Generator.new(config)
  generator.process do |manifest|
    generator.generators.each do |webgen|
      webgen.generate(manifest)
    end

    manifest.documents.each do |document|
      if document.type == :document
        if document.resource.has_example_bundle_js?
          File.write("src/#{document.name}-examples.js", document.resource.example_bundle_js)
        end
      end
    end
  end
end
