require 'rails_helper'

RSpec.describe "certificates/edit", type: :view do
  before(:each) do
    @certificate = assign(:certificate, Certificate.create!())
  end

  it "renders the edit certificate form" do
    render

    assert_select "form[action=?][method=?]", certificate_path(@certificate), "post" do
    end
  end
end
