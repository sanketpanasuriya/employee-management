# spec/models/employee_spec.rb

require 'rails_helper'
RSpec.describe Employee, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:department) }
    it { should validate_presence_of(:salary) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'PERMITTED_PARAMS constant' do
    it 'includes the expected attributes' do
      expected_params = %i[first_name last_name email department salary]
      expect(Employee::PERMITTED_PARAMS).to match_array(expected_params)
    end
  end
end
