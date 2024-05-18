class ThirdPartyEmployeeService < ApplicationService
  attr_reader :full_url
  def initialize
    @full_url = 'http://localhost:3000/api/v1/employees'
    @logger = Logger.new('log/third_party_employee.log')
  end

  def call
    response = HTTParty.get(full_url, headers: http_header)
    handle_response(response)
  rescue HTTParty::Error => e
    @logger.error("HTTParty error: #{e.message}")
    nil
  rescue StandardError => e
    @logger.error("Error fetching employee data: #{e.message}")
    nil
  end

  private

  def http_header
    {
      'API_TOKEN' => "TOKEN",
      'Accept' => 'application/json'
    }
  end

  def handle_response(response)
    return unless response.success?

    data = JSON.parse(response.body)['data']
    @logger.info("Data: #{data}")
    save_employee_data(data)
  end

  def save_employee_data(data)
    data.each do |employee|
      e = Employee.find_or_initialize_by(email: employee['email'])
      e.attributes = employee.slice(*Employee::PERMITTED_PARAMS.map(&:to_s))
      e.save
    end
  end
end
