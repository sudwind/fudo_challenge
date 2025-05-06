require_relative '../../../spec_helper'

RSpec.describe Interfaces::Web::Controllers::ProductsController do
  let(:create_product_use_case) { instance_double('UseCases::CreateProduct') }
  let(:search_products_use_case) { instance_double('UseCases::SearchProducts') }
  let(:find_product_use_case) { instance_double('UseCases::FindProduct') }
  let(:list_products_use_case) { instance_double('UseCases::ListProducts') }
  let(:controller) do
    described_class.new(
      create_product_use_case,
      search_products_use_case,
      find_product_use_case,
      list_products_use_case
    )
  end

  describe 'GET /products' do
    let(:products) do
      {
        'products' => [
          { 'id' => 'product_1', 'name' => 'Product 1' },
          { 'id' => 'product_2', 'name' => 'Product 2' }
        ]
      }
    end

    before do
      allow(list_products_use_case).to receive(:execute).and_return({
        products: [
          { id: 'product_1', name: 'Product 1' },
          { id: 'product_2', name: 'Product 2' }
        ]
      })
    end

    it 'returns all products' do
      env = Rack::MockRequest.env_for('/', method: 'GET')
      response = controller.call(env)

      expect(response[0]).to eq(200)
      expect(JSON.parse(response[2][0])).to eq(products)
    end
  end

  describe 'POST /products' do
    let(:product_data) { { name: 'New Product' } }

    before do
      allow(create_product_use_case).to receive(:execute).and_return({})
    end

    it 'accepts the product creation request' do
      env = Rack::MockRequest.env_for(
        '/',
        method: 'POST',
        'CONTENT_TYPE' => 'application/json',
        'rack.input' => StringIO.new(product_data.to_json)
      )
      response = controller.call(env)

      expect(response[0]).to eq(202)
      expect(create_product_use_case).to have_received(:execute).with(name: 'New Product')
    end
  end

  describe 'GET /products/search' do
    let(:search_results) do
      {
        'products' => [
          { 'id' => 'product_1', 'name' => 'Product 1' }
        ]
      }
    end

    before do
      allow(search_products_use_case).to receive(:execute).and_return({
        products: [
          { id: 'product_1', name: 'Product 1' }
        ]
      })
    end

    it 'returns search results' do
      env = Rack::MockRequest.env_for('/search?q=Product', method: 'GET')
      response = controller.call(env)

      expect(response[0]).to eq(200)
      expect(JSON.parse(response[2][0])).to eq(search_results)
      expect(search_products_use_case).to have_received(:execute).with(query: 'Product')
    end
  end

  describe 'GET /products/:id' do
    let(:product_id) { '123e4567-e89b-12d3-a456-426614174000' }
    let(:product) do
      {
        'id' => product_id,
        'name' => 'Product 1'
      }
    end

    before do
      allow(find_product_use_case).to receive(:execute).and_return({
        id: product_id,
        name: 'Product 1'
      })
    end

    it 'returns the product' do
      env = Rack::MockRequest.env_for("/#{product_id}", method: 'GET')
      response = controller.call(env)

      expect(response[0]).to eq(200)
      expect(JSON.parse(response[2][0])).to eq(product)
      expect(find_product_use_case).to have_received(:execute).with(id: product_id)
    end
  end
end 