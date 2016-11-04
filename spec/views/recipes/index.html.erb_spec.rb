require 'rails_helper'

RSpec.describe "recipes/index", type: :view do
  before(:each) do
    assign(:recipes, [
      Recipe.create!(
        :name => "Name",
        :url => "Url",
        :instructions => "MyText",
        :picture_url => "Picture Url",
        :menu_type => "Menu Type"
      ),
      Recipe.create!(
        :name => "Name",
        :url => "Url",
        :instructions => "MyText",
        :picture_url => "Picture Url",
        :menu_type => "Menu Type"
      )
    ])
  end

  it "renders a list of recipes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Picture Url".to_s, :count => 2
    assert_select "tr>td", :text => "Menu Type".to_s, :count => 2
  end
end
