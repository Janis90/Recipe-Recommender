class Event < ActiveRecord::Base
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  belongs_to :creator, class_name: "User"

  validates :title,       presence: true
  validates :date,        presence: true
  validates :start_time,  presence: true
end
