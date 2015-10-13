class FileStorage
  class << self
    def store_uploaded_file(file)
      name = file.original_filename
      path = File.join(directory, name)
      File.open(path, 'wb') { |f| f.write(file.read) }
      path
    end

    def get_file(file_name)
      File.join(directory, file_name)
    end

    def directory
      'public/imports'
    end
  end
end
