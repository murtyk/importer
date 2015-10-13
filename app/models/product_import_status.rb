class ProductImportStatus < ImportStatus
  def imported_rows
    products = Product.where(id: success_ids)
    products.map do |product|
      [
        product.id,
        product.category_description,
        product.description,
        product.price || 'Can not sell. Price missing'
      ]
    end
  end

  def show_template
    'show_products'
  end
end
