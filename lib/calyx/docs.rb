module Calyx
  module Docs
    class Documents < Yarrow::Schema::Entity
      attribute :name, :string
      attribute :title, :string
    end

    class Document < Yarrow::Schema::Entity
      attribute :name, :string
      attribute :title, :string
      attribute :body, :markdown

      def body_html
        body.to_html
      end
    end
  end
end
