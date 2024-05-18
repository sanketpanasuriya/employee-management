class Employee < ApplicationRecord
  validates :first_name, :last_name, :email, :department, :salary, presence: true
  validates :email, uniqueness: true
end
