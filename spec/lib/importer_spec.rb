require 'rails_helper'
require './lib/importer/file_reader.rb'
require './lib/importer/excel_reader.rb'
require './lib/importer/importer.rb'
# require 'roo'
# require 'byebug'
class MockImportStatus
  attr_reader :success_ids, :errors, :file_name, :type, :model_name
  def initialize
    @success_ids = []
    @errors = {}
  end

  def update(params)
    @file_name = params[:file_name]
    @status = params[:status]
    @model_name = params[:model_name]
  end

  def update_status(object, row_index, _row)
    @success_ids << object.id unless object.errors.any?
    return unless object.errors.any?

    errors[row_index] = object.errors
  end
end

class MockImporter < Importer
  def required_attrs
    %w(attr1 attr2)
  end

  def import_row(row)
    MockModel.create(row)
  end
end

class MockModel
  attr_reader :errors, :id

  @@object_id = 0

  def initialize(id = nil, error = nil)
    @id = id
    @errors = error ? [error] : []
  end

  def self.create(row)
    return new(next_id) if row['attr1'].to_i > 0
    new(nil, 'attr1 is not integer')
  end

  def self.next_id
    @@object_id += 1
  end
end

describe Importer do
  it 'instantiates model specific importer and status objects' do
    params   = { model: 'mock' }
    importer = Importer.new_importer(params, MockImportStatus.new)
    status = importer.import_status

    expect(importer.class.name == 'MockImporter').to be_truthy
    expect(status.class.name == 'MockImportStatus').to be_truthy
  end

  it 'imports and provides status information' do
    params   = { model: 'mock', file_path: './spec/fixtures/test.xlsx' }
    importer = Importer.new_importer(params, MockImportStatus.new)

    importer.import
    status   = importer.import_status
    error_messages = status.errors.values.flatten
    expect(status.success_ids[0]).to eql(1)
    expect(error_messages.include?('attr1 is not integer')).to be_truthy
  end
end
