class Product < ActiveRecord::Base
  belongs_to :category

  delegate :code, :description,
           to: :category, allow_nil: :false, prefix: true

  validates_presence_of :category, message: 'is blank or invalid'
  validates_presence_of :description
end
