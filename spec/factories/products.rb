FactoryBot.define do
  factory :product, class: Domain::Models::Product do
    sequence(:id) { |n| "product_#{n}" }
    sequence(:name) { |n| "Product #{n}" }

    initialize_with { new(id: id, name: name) }
  end
end 