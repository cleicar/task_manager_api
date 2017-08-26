class Api::V2::ArraySerializer < ActiveModel::Serializer
  attributes :_id, :title, :description, :done, :deadline, :user_id, :created_at,
  	:updated_at, :short_description, :is_late

  def short_description
  	debugger
    object.description[0..40]
  end

  def is_late
  	debugger
    Time.current > object.deadline if object.deadline.present?
  end

  belongs_to :user
end
