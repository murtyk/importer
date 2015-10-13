class ImporterForm
  include ActiveModel::Model
  # extend ActiveModel::Naming
  # include ActiveModel::Conversion

  attr_accessor :file, :model

  attr_reader :importer

  def initialize(importer)
    self.model = importer.model
    @importer = importer

    importer.errors.each { |msg| errors.add(:base, msg) }
  end

  def persisted?
    false
  end

  def title
    importer.title
  end

  def user_instructions
    importer.user_instructions
  end
end
