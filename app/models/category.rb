class Category < ActiveRecord::Base
  has_many :products

  validates_uniqueness_of :code
  validates_presence_of :description
end
