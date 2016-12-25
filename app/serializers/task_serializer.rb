class TaskSerializer < ActiveModel::Serializer
  attributes :title, :description

  belongs_to :list
end
