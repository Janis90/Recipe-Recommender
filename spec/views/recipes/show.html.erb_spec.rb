require 'rails_helper'

RSpec.describe "recipes/show", type: :view do
  before(:each) do
    @recipe = assign(:recipe, Recipe.create!(
      :name => "Name",
      :url => "Url",
      :instructions => "MyText",
      :picture_url => "Picture Url",
      :menu_type => "Menu Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Picture Url/)
    expect(rendered).to match(/Menu Type/)
  end
end
