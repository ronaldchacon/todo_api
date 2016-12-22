class List < ApplicationRecord
  has_many :tasks

  validates :title, presence: true

  @sort_attributes = %w(id title)

  class << self
    attr_accessor :sort_attributes
  end
end
