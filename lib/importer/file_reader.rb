# base class for FiletypeReader
class FileReader
  attr_reader :header, :file_path, :file_name, :file_data

  def initialize(file_path)
    @file_path = file_path

    @file_name = file_path.split('/')[-1]

    post_initialize
  end

  def valid_header?(required_attrs)
    (header & required_attrs).size == required_attrs.size
  end

  private

  def post_initialize
    fail 'subclass should implment post_initialize method'
  end

  def read_a_row
    fail 'subclass should implment read_a_row method'
  end

  def close
    fail 'subclass should implment read_a_row method'
  end
end
