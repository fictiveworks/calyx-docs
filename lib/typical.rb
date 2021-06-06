require "yarrow"
require "calyx"

# Preconditions:
# - Generates a target path
# - Generates a target dir
# - Parses the source file into a document representation
#
# Effects:
# - Creates output directory tree if none exists
# - Writes the document representation into a file at the target path
#
# @param source_path [Path, String] path to the file on disk
def build_document(source_path)
  doc_title, target_doc = parse_document(source_path)
  target_path = "#{WEB_DIR}/#{source_path.gsub('.md', '.html')}"
  target_dir = File.dirname(target_path)
  FileUtils.mkdir_p(target_dir) unless File.directory?(target_dir)
  File.write(target_path, render_document(doc_title, target_doc))
  append_index(target_path, doc_title)
end

AttributeDefinition = Yarrow::Schema::Value.new(:name, :type, :options, :effects)

class AttributeContext
  def initialize
    @registry = {}
  end

  def define_attr(name, type, options: {}, effects: {})
    @registry[name] = AttributeDefinition.new(name, type, options, effects)
  end

  def method_missing(name, type, options: {}, effects: {})
    define_attr(name, type, options, effects)
  end

  
end

module Yarrow
  class Entity
    def self.define(&block)
      context = AttributeContext.new(self)
      context.instance_eval(&block)
    end
  end
end

# Instead of taking a source path, take an entity that maps to a
# document template and content format.
#
# Essay = Yarrow::Entity.load("types/essay.yyml")
# Essay = Yarrow::Entity.load(:essay)
#
# build_document(document)
#
Essay = Yarrow::Entity.define do
  id :guid
  title :string
  name :identifier
end
