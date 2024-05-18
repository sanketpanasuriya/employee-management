class Employee < ApplicationRecord
  PERMITTED_PARAMS = %i[first_name last_name email department salary]

  validates :first_name, :last_name, :email, :department, :salary, presence: true
  validates :email, uniqueness: true
end
