require 'rails_helper'

RSpec.describe "allergies/edit", type: :view do
  before(:each) do
    @allergy = assign(:allergy, Allergy.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit allergy form" do
    render

    assert_select "form[action=?][method=?]", allergy_path(@allergy), "post" do

      assert_select "input#allergy_name[name=?]", "allergy[name]"
    end
  end
end
