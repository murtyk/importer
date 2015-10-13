class ImportersController < ApplicationController
  def new
    importer = Importer.new_importer(new_params)
    @importer_form = ImporterForm.new(importer)
  end

  def create
    importer = Importer.new_importer(importer_params)
    importer.validate

    if importer.errors.any?
      @importer_form = ImporterForm.new(importer)
      render 'new'
      return
    end

    @import_status = importer.import_status
    importer.delay.import
  end

  def importer_params
    file = params[:importer_form][:file]
    return { model: params[:importer_form][:model] } unless file

    file_path = FileStorage.store_uploaded_file(file)

    { file_path: file_path, model: params[:importer_form][:model] }
  end

  def new_params
    params.permit(:model)
  end
end
