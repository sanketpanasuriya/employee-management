class ThirdPartyEmployeeJob
  include Sidekiq::Job

  def perform()
    ThirdPartyEmployeeService.call()
  end
end
