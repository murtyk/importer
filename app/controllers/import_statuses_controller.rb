class ImportStatusesController < ApplicationController
  def show
    @import_status = ImportStatus.find params[:id]

    respond_to do |format|
      format.json { render json: @import_status.status_data }
      format.html { render @import_status.show_template }
    end
  end

  def index
    @import_statuses = ImportStatus.all
  end
end
