require 'rails_helper'

RSpec.describe "certificates/show", type: :view do
  before(:each) do
    @certificate = assign(:certificate, Certificate.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
