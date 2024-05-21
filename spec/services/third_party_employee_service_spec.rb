require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ThirdPartyEmployeeService, type: :service do
  let(:full_url) { 'http://localhost:3000/api/v1/employees' }
  let(:headers) { { 'API_TOKEN' => 'TOKEN', 'Accept' => 'application/json' } }
  let(:service) { described_class.new }

  before do
    @logger = double("Logger")
    allow(Logger).to receive(:new).and_return(@logger)
    allow(@logger).to receive(:error)
    allow(@logger).to receive(:info)
  end

  describe '#call' do
    context 'when the request is successful' do
      let(:response_body) do
        {
          type: 'Success',
          status: 'ok',
          message: 'Employees retrieved successfully',
          data: [
            { 'id' => 1, 'first_name' => 'Sanket', 'last_name' => 'Patel', 'email' => 'xyz@example.com', 'department' => 'IT', 'salary' => 50000 },
            { 'id' => 2, 'first_name' => 'Sanket', 'last_name' => 'Panasuriya', 'email' => 'sanket@example.com', 'department' => 'HR', 'salary' => 60000 }
          ]
        }.to_json
      end

      before do
        stub_request(:get, full_url).with(headers: headers).to_return(status: 200, body: response_body, headers: {})
      end

      it 'logs the retrieved data' do
        service.call
        expect(@logger).to have_received(:info).with("Data: #{JSON.parse(response_body)['data']}")
      end

      it 'saves the employee data' do
        expect { service.call }.to change { Employee.count }.by(2)
      end
    end

    context 'when the data has duplicate emails' do
      let!(:existing_employee) { Employee.create(first_name: 'Elanor', last_name: 'Beatty', email: 'elanor.beatty@example.com', department: 'IT', salary: 45000) }
      let(:response_body) do
        {
          type: 'Success',
          status: 'ok',
          message: 'Employees retrieved successfully',
          data: [
            { 'id' => 2, 'first_name' => 'Elanor', 'last_name' => 'Beatty', 'email' => 'elanor.beatty@example.com', 'department' => 'IT', 'salary' => 50000 },
            { 'id' => 3, 'first_name' => 'Jane', 'last_name' => 'Smith', 'email' => 'jane.smith@example.com', 'department' => 'HR', 'salary' => 60000 }
          ]
        }.to_json
      end

      before do
        stub_request(:get, full_url).with(headers: headers).to_return(status: 200, body: response_body, headers: {})
      end

      it 'updates the existing employee record' do
        expect { service.call }.to change { Employee.count }.by(1)
        existing_employee.reload
        expect(existing_employee.salary).to eq(50000)
      end
    end

    context 'when the request fails' do
      before do
        stub_request(:get, full_url).with(headers: headers).to_return(status: 500, body: '', headers: {})
      end

      it 'does not save any employee data' do
        expect { service.call }.not_to change { Employee.count }
      end
    end

    context 'when there is an HTTParty error' do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::Error.new('HTTParty error'))
      end

      it 'logs the HTTParty error' do
        service.call
        expect(@logger).to have_received(:error).with('HTTParty error: HTTParty error')
      end

      it 'returns nil' do
        expect(service.call).to be_nil
      end
    end

    context 'when there is a StandardError' do
      before do
        allow(HTTParty).to receive(:get).and_raise(StandardError.new('Some error'))
      end

      it 'logs the error' do
        service.call
        expect(@logger).to have_received(:error).with('Error fetching employee data: Some error')
      end

      it 'returns nil' do
        expect(service.call).to be_nil
      end
    end
  end
end
