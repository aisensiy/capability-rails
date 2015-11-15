require 'rails_helper'

RSpec.describe "certificates/index", type: :view do
  before(:each) do
    assign(:certificates, [
      Certificate.create!(),
      Certificate.create!()
    ])
  end

  it "renders a list of certificates" do
    render
  end
end
