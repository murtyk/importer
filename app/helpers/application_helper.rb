module ApplicationHelper
  def asset_exists?(filename, extension)
    asset_pathname = "#{Rails.root}/app/assets/"
    asset_file_path = "#{asset_pathname}/#{filename}".split('.')[0]
    !Dir.glob("#{asset_file_path}.#{extension}*").empty?
  end

  def js_asset_exists?(filename)
    asset_exists?("javascripts/#{filename}", 'js')
  end
end
