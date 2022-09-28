# frozen_string_literal: true

module Pipedrive
  class Deal < Resource
    include Fields
    include Merge

    has_many :products, class_name: "Product"
    has_many :persons, class_name: "Person"
    
    # POST /deals/:id/products
    # Add a product to this deal
    def add_product(product, params)
      raise "Param *product* is not an instance of Pipedrive::Product" \
        unless product.is_a?(Pipedrive::Product)
      raise "Param :item_price is required" unless params.key?(:item_price)
      raise "Param :quantity is required" unless params.key?(:quantity)

      response = request(
        :post,
        "#{resource_url}/products",
        params.merge(id: id, product_id: product.id)
      )
      Product.new(response.dig(:data))
    end

    # DELETE /deals/:id/products/:product_attachment_id
    # Detach a product from this deal
    def delete_attached_product(product_attachment_id)
      response = request(:delete, "#{resource_url}/products/#{product_attachment_id}")
      response[:success]
    end
  end
end
