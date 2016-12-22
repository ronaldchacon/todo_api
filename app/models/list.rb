class List < ApplicationRecord
  has_many :tasks

  validates :title, presence: true

  @sort_attributes = %w(id title)
  @filter_attributes = %w(id title created_at)

  class << self
    attr_accessor :sort_attributes, :filter_attributes
  end
end
