class ImportStatus < ActiveRecord::Base
  enum status: [:inactive, :started, :processing, :finished]

  attr_accessor :model

  after_initialize { self.data ||= {} }
  before_save { self.type ||= model.capitalize + 'ImportStatus' }

  def update_status(object, row_index, row)
    update_success(object) unless object.errors.any?
    update_fail(object, row_index, row) if object.errors.any?
  end

  def update_success(object)
    success_ids << object.id
  end

  def update_fail(object, row_index, row)
    fail_data = { errors: object.errors.full_messages, row_data: row }
    self.data[row_index] = fail_data.to_json
    save
  end

  # following are for views. subclass can override.
  def status_data
    {
      status: status,
      count_failed: count_failed,
      count_succeeded: count_succeeded
    }
  end

  def failed_rows
    data.map do |r_no, rd|
      row = JSON.parse rd
      errors = row['errors'].join('<br>')
      r_data = row['row_data'].map { |k, v| "#{k}=#{v}" }.join('<br>')
      [r_no, errors, r_data]
    end
  end

  def count_succeeded
    success_ids.size
  end

  def count_failed
    data.size
  end

  def count_rows
    count_succeeded + data.size
  end

  def show_template
    'show'
  end
end
