class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :done, type: Mongoid::Boolean, default: false
  field :deadline, type: Time

  validates_presence_of :title, :user_id

  belongs_to :user
end
