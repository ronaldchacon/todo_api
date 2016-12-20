class TaskSerializer < ActiveModel::Serializer
  attributes :title

  belongs_to :list
end
