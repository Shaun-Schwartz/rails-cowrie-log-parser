class Log < ApplicationRecord
  # validates :time, presence: true
  has_many :captures, dependent: :destroy 
end
