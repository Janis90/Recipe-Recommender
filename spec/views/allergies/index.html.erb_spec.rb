require 'rails_helper'

RSpec.describe "allergies/index", type: :view do
  before(:each) do
    assign(:allergies, [
      Allergy.create!(
        :name => "Name"
      ),
      Allergy.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of allergies" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
