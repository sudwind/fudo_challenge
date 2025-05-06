# typed: true
module Domain
  module Models
    class Product
      attr_reader :id, :name

      def initialize(id:, name:)
        @id = id
        @name = name
      end

      def to_h
        {
          id: @id,
          name: @name
        }
      end
    end
  end
end 