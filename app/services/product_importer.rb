class ProductImporter < Importer
  def required_attrs
    %w(category_code description price)
  end

  def optional_attrs
    %w(supplier)
  end

  def import_row(row)
    category = Category.find_by(code: alphanumeric(row['category_code']))
    Product.create(category_id: category.try(:id),
                   description: row['description'],
                   price: row['price'])
  end

  def title
    'Import Products Data'
  end

  def user_instructions
    '<p>Make sure valid category code is specified in the file</p>'.html_safe
  end
end
