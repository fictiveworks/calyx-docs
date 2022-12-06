require "rouge"
require "components/example_console"

Yarrow::Schema.define do
  type :gfm, Yarrow::Schema::Types::Instance.of(Kramdown::CustomDocument).accept(String, :new, { input: "GFM", syntax_highlighter: "rouge"})
end

module Calyx
  module Docs
    class Documents < Yarrow::Schema::Entity
      attribute :name, :string
      attribute :title, :string
      attribute :body, :gfm
      #attribute :layout, :string

      def is_home?
        name == "content"
      end

      def is_doc_index?
        name != "content"
      end

      def body_html
        body.to_html
      end

      def crumb_url
        if name == "content"
          "/"
        else
          "/#{name}/"
        end
      end

      def crumb_title
        if name == "content"
          "Home"
        else
          title
        end
      end
    end

    class Document < Yarrow::Schema::Entity
      attribute :name, :string
      attribute :title, :string
      attribute :body, :gfm

      def is_guide?
        true
      end

      def body_html
        body.to_html
      end

      def example_bundle_js
        return unless body.custom_elements.any? { |el| el.has_runnable_custom_elements? }
        bundle = <<-BUNDLE
import calyx from "calyx";

#{body.custom_elements.map(&:to_js).join("\n\n")}

const exampleHandlers = {
  #{body.custom_elements.map(&:name).join(", ")}
};

document.addEventListener("example-console:run", (ev) => {
  const result = exampleHandlers[ev.detail.name]();
  ev.detail.run(result);
})
BUNDLE
      end

      def has_example_bundle_js?
        body.custom_elements.any? { |el| el.has_runnable_custom_elements? }
      end
    end
    #
    # class Bundle
    #   def initialize(custom_elements)
    #     @custom_elements = custom_elements
    #   end
    #
    #   def console_run_handler
    #     %w(document.addEventListener("example-console:run", (ev) => {
    #       const result = exampleHandlers[ev.detail.name]();
    #       ev.detail.run(result);
    #     }))
    #   end
    # end
  end
end
