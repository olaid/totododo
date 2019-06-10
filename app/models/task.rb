class Task < ApplicationRecord
  validates :name, presence: true
  validates :next_task, presence: true,uniqueness: true
end
