require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let!(:employee) { create(:employee) }
  let(:valid_attributes) { attributes_for(:employee) }
  let(:invalid_attributes) { { first_name: '', last_name: '', email: '', department: '', salary: nil } }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: employee.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: employee.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Employee' do
        expect {
          post :create, params: { employee: valid_attributes }
        }.to change(Employee, :count).by(1)
      end

      it 'redirects to the created employee' do
        post :create, params: { employee: valid_attributes }
        expect(response).to redirect_to(Employee.last)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e., to display the "new" template)' do
        post :create, params: { employee: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { first_name: 'New', last_name: 'Name', email: 'new@example.com', department: 'New Dept', salary: 123456 }
      }

      it 'updates the requested employee' do
        put :update, params: { id: employee.to_param, employee: new_attributes }
        employee.reload
        expect(employee.first_name).to eq('New')
        expect(employee.last_name).to eq('Name')
        expect(employee.email).to eq('new@example.com')
        expect(employee.department).to eq('New Dept')
        expect(employee.salary).to eq(123456)
      end

      it 'redirects to the employee' do
        put :update, params: { id: employee.to_param, employee: new_attributes }
        expect(response).to redirect_to(employee)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested employee' do
      expect {
        delete :destroy, params: { id: employee.to_param }
      }.to change(Employee, :count).by(-1)
    end

    it 'redirects to the employees list' do
      delete :destroy, params: { id: employee.to_param }
      expect(response).to redirect_to(employees_url)
    end
  end
end
