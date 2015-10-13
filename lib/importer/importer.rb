# base class for ModelImporter.
# Does heavy lifting.
# ModelImporter should implement model specific logic
class Importer
  attr_reader :file_reader, :file_path,
              :model, :import_status,
              :object, :row_index, :errors

  def initialize(params, import_status)
    @errors    = []
    @model     = params[:model]
    @file_path = params[:file_path]
    @import_status = import_status
  end

  def self.new_importer(params, import_status = ImportStatus.new)
    model_name     = params[:model].capitalize
    importer_class = Object.const_get "#{model_name}Importer"

    importer_class.new(params, import_status)
  end

  def import
    init_import_process

    while (row = file_reader.read_a_row)
      attrs = row.slice(*permitted_attrs)

      @object = import_row(attrs)
      update_object_status(attrs)

      @row_index += 1
    end

    update_object_status(nil, true)
  end

  def init_import_status
    import_status.update(status: 'started',
                         file_name: file_name,
                         model: model)
  end

  def validate
    return unless validate_file
    return unless validate_header
    init_import_status if errors.empty?
  end

  def validate_file
    @errors << 'File Missing' unless file_path
    file_path
  end

  def validate_header
    fr = ExcelReader.new(file_path)
    valid = fr.valid_header?(required_attrs)
    @errors << 'Invalid Header' unless valid
    valid
  end

  # the following are for view. subclasses should override
  def title
    'Import'
  end

  def user_instructions
    'Instructions for Upload:'
  end

  private

  def required_attrs
    fail 'subclass has to implement required_attrs'
  end

  def init_import_process
    @row_index     = 2
    @file_reader   = ExcelReader.new(file_path)
  end

  def import_row(_row)
    fail 'subclass should implement import_row'
  end

  def update_object_status(row, finished = false)
    @status = finished ? 'finished' : 'processing'
    return import_status.update(status: @status) if finished
    import_status.update_status(object, row_index, row)
  end

  def file_name
    file_path.split('/')[-1]
  end

  def optional_attrs
    []
  end

  def permitted_attrs
    required_attrs + optional_attrs
  end

  # for data cleansing

  def alphanumeric(s)
    s = s.to_i.to_s if s.is_a? Float
    s.to_s.delete('^0-9a-zA-Z')
  end
end
