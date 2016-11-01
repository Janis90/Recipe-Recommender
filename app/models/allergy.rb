class Allergy < ActiveRecord::Base
  has_many :user_allergy, dependent: :destroy
  has_many :users, through: :user_allergy
  validates :name, presence: true
end
