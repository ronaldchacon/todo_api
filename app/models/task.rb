class Task < ApplicationRecord
  belongs_to :list

  validates :title, presence: true
  validates :list_id, presence: true
end
