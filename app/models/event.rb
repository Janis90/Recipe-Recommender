class Event < ActiveRecord::Base
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  belongs_to :creator, class_name: "User"

  validates :title,       presence: true
  validates :start_time,  presence: true
  validate :validate_end_time
  validate :validate_date

  after_initialize :set_default_date

  #end_time can not be before start time
  def validate_end_time
    if self.end_time.present? && self.end_time < self.start_time
      errors.add(:end_time, "can't be before start time")
    end
  end

  #date can't be in the past
  def validate_date
    if self.date.present? && self.date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end

  def set_default_date
    self.date ||= Date.today if new_record?
  end
end
