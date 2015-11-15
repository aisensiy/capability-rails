require 'rails_helper'

RSpec.describe "certificates/new", type: :view do
  before(:each) do
    assign(:certificate, Certificate.new())
  end

  it "renders new certificate form" do
    render

    assert_select "form[action=?][method=?]", certificates_path, "post" do
    end
  end
end
