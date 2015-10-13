# reads rows from excel file
class ExcelReader < FileReader
  attr_reader :row_index

  def read_a_row
    return unless row_index <= file_data.last_row
    row = Hash[[header, file_data.row(row_index)].transpose]

    @row_index += 1

    row
    # row.with_indifferent_access
  end

  private

  def post_initialize
    @file_data = open
    read_header
    @row_index = 2
  end

  def read_header
    @header = file_data.row(1)
  end

  def open
    case File.extname(file_name)
    when '.xls' then Roo::Excel.new(file_path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file_path,
                                      packed: nil,
                                      file_warning: :ignore)
    else fail "Invalid file type: #{file_name}"
    end
  end

  def close
    @file_data = nil
  end
end
