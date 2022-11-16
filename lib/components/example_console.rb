require "kramdown-components"
require "kramdown-parser-gfm"

module Components
  class ExampleConsole < Kramdown::CustomElement
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

    RUNNABLE_LANGS = ["js", "javascript"]

    def name
      id.gsub("-", "_")
    end

    def to_js
      "function #{name}(action) {\n#{gen_js_body}\n}" if @runnable
    end

    def parse_dom(root)
      codeblocks = root.children.filter { |child_el| child_el.type == :codeblock }

      return if codeblocks.empty?

      root.children = codeblocks.map do |codeblock|
        codeblock.options[:lang]

        wrapper = Kramdown::Element.new(
          :html_element,
          "example-script",
          { label: LANG_LABELS[codeblock.options[:lang]] },
          { content_model: :block }
        )
        wrapper.children << codeblock
        wrapper
      end

      runnable_languages = codeblocks.find do |codeblock|
        RUNNABLE_LANGS.include?(codeblock.options[:lang])
      end

      @runnable = runnable_languages.value unless runnable_languages.nil?

      root.children.first.attr[:selected] = true unless root.children.first.nil?
    end

    def has_runnable_custom_elements?
      !@runnable.nil?
    end

    private

    def gen_js_body
      lines = @runnable.split("\n").reject { |line| line.start_with?("import") }
      result_ret = lines.last.lstrip
      lines[lines.count - 1] = "return #{result_ret}"
      "\s\s" + lines.join("\n\s\s")
    end
  end
end

Kramdown::CustomDocument.define_element("example-console", Components::ExampleConsole)
Kramdown::CustomDocument.define_element("example-script", Kramdown::CustomElement)
