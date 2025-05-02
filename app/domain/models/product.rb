module Domain
  module Models
    class Product
      attr_reader :id, :name, :description, :price, :created_at, :updated_at

      def initialize(id:, name:, description:, price:, created_at: Time.now, updated_at: Time.now)
        @id = id
        @name = name
        @description = description
        @price = price
        @created_at = created_at
        @updated_at = updated_at
      end

      def to_h
        {
          id: id,
          name: name,
          description: description,
          price: price,
          created_at: created_at,
          updated_at: updated_at
        }
      end
    end
  end
end 