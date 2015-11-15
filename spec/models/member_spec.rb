require 'rails_helper'

RSpec.describe Member, type: :model do
  it 'should create new assignment' do
    manager = create :manager
    manager2 = create(:manager, name: 'new')
    employee = create :employee
    employee.assign_to manager
    expect(employee.assign).to eq(manager)

    employee.assign_to manager2
    expect(employee.assign).to eq(manager2)
  end
end
