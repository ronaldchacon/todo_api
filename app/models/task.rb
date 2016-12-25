class Task < ApplicationRecord
  belongs_to :list

  validates :title, presence: true
  validates :list_id, presence: true

  @sort_attributes = %w(id title)
  @filter_attributes = %w(id title created_at)

  class << self
    attr_accessor :sort_attributes, :filter_attributes
  end
end
