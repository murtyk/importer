class CategoryImporter < Importer
  def required_attrs
    %w(code description)
  end

  def import_row(row)
    Category.create(clean(row))
  end

  def clean(row)
    row['code'] = alphanumeric(row['code'])
    row
  end
end
