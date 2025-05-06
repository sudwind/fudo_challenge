require_relative '../spec_helper'

RSpec.describe Domain::UseCases::ListProducts do
  let(:repository) { instance_double('Infrastructure::Repositories::PostgresRepository') }
  let(:use_case) { described_class.new(repository) }

  describe '#execute' do
    let(:products) do
      [
        build(:product, id: 'product_1', name: 'Product 1'),
        build(:product, id: 'product_2', name: 'Product 2')
      ]
    end

    before do
      allow(repository).to receive(:all_products).and_return(products)
    end

    it 'returns all products' do
      result = use_case.execute

      expect(result).to eq({
        products: [
          { id: 'product_1', name: 'Product 1' },
          { id: 'product_2', name: 'Product 2' }
        ]
      })
    end
  end
end 