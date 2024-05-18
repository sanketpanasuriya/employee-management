# frozen_string_literal: true

class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :department, :salary
end
