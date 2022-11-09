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
    end

    class Document < Yarrow::Schema::Entity
      attribute :name, :string
      attribute :title, :string
      attribute :body, :gfm

      def body_html
        body.to_html
      end

      def example_bundle_js
        return if body.custom_elements.empty?
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
    end
  end
end
