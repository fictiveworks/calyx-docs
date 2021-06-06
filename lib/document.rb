require "kramdown"

module Javascript
  class CalyxFunction
    attr_reader :name, :exports, :body

    def initialize(name, body, exports=false)
      @name = name
      @lines = body.lines
      @exports = exports
    end

    def to_s
      "function #{name}(action) {\n#{gen_body}\n}\n"
    end

    def gen_body
      @lines[@lines.count - 1] = "return #{@lines.last}"
      @lines.join("")
    end
  end
end

class ExampleConsole
  attr_reader :id, :runnable

  def initialize(id, outer_el)
    @id = id
    @runnable = collect_runnable(outer_el)
  end

  def to_js
    binding = id.gsub("-", "")
    js_callable = Javascript::CalyxFunction.new(binding, @runnable)
    js_callable.to_s
  end

  private

  def collect_runnable(outer_el)
    outer_el.children.map do |inner_el|
      if inner_el.value == "example-code"
        next unless inner_el.attr.key?("runnable")

        inner_el.children.each do |inner_block|
          return inner_block.value
        end
      end
    end
  end
end

module Extensions
  class Document
    def self.define_element(name, element)
      @@custom_elements ||= {}
      @@custom_elements[name.to_s] = element
    end

    def initialize(path, source)
      @path = path
      @source = source
      @parsed_dom = Kramdown::Document.new(@source, input: "GFM", syntax_highlighter: "rouge")
    end

    def to_html
      @parsed_dom.to_html
    end

    def has_js?
      !custom_elements.empty?
    end

    def to_js
      custom_elements.map(&:to_js).join("\n\n")
    end

    def custom_elements
      elements = []

      @parsed_dom.root.children.each do |outer_el|
        if outer_el.type == :html_element && @@custom_elements.keys.include?(outer_el.value)
          raise "Missing ID attribute in <#{outer_el.value}> (`#{@path}` at line #{outer_el.options[:location]})" unless outer_el.attr.key?("id")
          custom_element = @@custom_elements[outer_el.value]
          elements << custom_element.new(outer_el.attr["id"], outer_el)
        end
      end

      elements
    end
  end
end

Extensions::Document.define_element("example-console", ExampleConsole)
