require "kramdown"
require "kramdown-parser-gfm"

module Kramdown
  module Converter
    class Html
      def convert_nav(el, indent)
        format_as_block_html("nav", el.attr, inner(el, indent), indent)
      end

      def convert_button(el, indent)
        format_as_block_html("button", el.attr, LANG_LABELS[el.value], indent)
      end
    end
  end
end

JS_LABEL = "JavaScript"
CS_LABEL = "C#"
RB_LABEL = "Ruby"
JSON_LABEL = "JSON"

LANG_LABELS = {
  "js" => JS_LABEL,
  "javascript" => JS_LABEL,
  "cs" => CS_LABEL,
  "rb" => RB_LABEL,
  "ruby" => RB_LABEL,
  "json" => JSON_LABEL
}

module Javascript
  class CalyxFunction
    attr_reader :name, :exports, :body

    def initialize(name, body, exports=false)
      @name = name
      @lines = body.reject { |line| line.nil? }
      @exports = exports
    end

    def to_s
      "function #{name}(action) {\n#{gen_body}\n}\n"
    end

    def gen_body
      # TODO: generate function return and handle console.log or print
      #@lines[@lines.count - 1] = "return #{@lines.last}"
      @lines.join("")
    end
  end
end

class ExampleConsole
  attr_reader :id, :runnable

  def initialize(id, outer_el)
    @id = id
    @outer_el = outer_el
    @runnable = collect_runnable(outer_el)
  end

  def to_js
    binding = id.gsub("-", "")
    js_callable = Javascript::CalyxFunction.new(binding, @runnable)
    js_callable.to_s
  end

  def create_tab_nav
    tabs = Kramdown::Element.new(:nav, nil, class: "example-tabs")
    @outer_el.children.each do |inner_el|
      if inner_el.type == :codeblock
        tabs.children << Kramdown::Element.new(:button, inner_el.options[:lang])
      end
    end
    tabs
  end

  private

  RUNNABLE_LANGS = ["js", "javascript"]

  def collect_runnable(outer_el)
    outer_el.children.map do |inner_el|
      if RUNNABLE_LANGS.include?(inner_el.options[:lang])
        #p inner_el.value
      end
      # if inner_el.value == "example-code"
      #   next unless inner_el.attr.key?("runnable")
      #
      #   inner_el.children.each do |inner_block|
      #     return inner_block.value
      #   end
      # end
    end
  end
end

module Extensions
  class Document
    def self.define_element(name, element)
      tag_name = name.downcase
      Kramdown::Parser::Html::Constants::HTML_ELEMENT[tag_name] = true
      Kramdown::Parser::Html::Constants::HTML_CONTENT_MODEL[tag_name] = :block
      @@custom_elements ||= {}
      @@custom_elements[tag_name] = element
    end

    def initialize(path, source)
      @path = path
      @source = source
      @parsed_dom = Kramdown::Document.new(@source, {
        input: "GFM",
        parse_block_html: true,
        syntax_highlighter: "rouge"
      })
      @custom_elements = extract_custom_elements
    end

    def to_html
      @parsed_dom.to_html
    end

    def has_js?
      !@custom_elements.empty?
    end

    def to_js
      @custom_elements.map(&:to_js).join("\n\n")
    end

    def extract_custom_elements
      elements = []

      @parsed_dom.root.children.each do |outer_el|
        if outer_el.type == :html_element && @@custom_elements.keys.include?(outer_el.value)
          raise "Missing ID attribute in <#{outer_el.value}> (`#{@path}` at line #{outer_el.options[:location]})" unless outer_el.attr.key?("id")
          custom_element_cls = @@custom_elements[outer_el.value]
          element = custom_element_cls.new(outer_el.attr["id"], outer_el)

          codeblocks = outer_el.children.filter { |child_el| child_el.type == :codeblock }

          outer_el.children = codeblocks.map do |codeblock|
            wrapper = Kramdown::Element.new(
              :html_element,
              "example-script",
              { label: LANG_LABELS[codeblock.options[:lang]] },
              { content_model: :block }
            )
            wrapper.children << codeblock
            wrapper
          end

          outer_el.children.first.attr[:selected] = true

          elements << element
        end
      end

      elements
    end
  end
end

Extensions::Document.define_element("example-console", ExampleConsole)
