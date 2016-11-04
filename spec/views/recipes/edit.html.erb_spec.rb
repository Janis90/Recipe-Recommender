require 'rails_helper'

RSpec.describe "recipes/edit", type: :view do
  before(:each) do
    @recipe = assign(:recipe, Recipe.create!(
      :name => "MyString",
      :url => "MyString",
      :instructions => "MyText",
      :picture_url => "MyString",
      :menu_type => "MyString"
    ))
  end

  it "renders the edit recipe form" do
    render

    assert_select "form[action=?][method=?]", recipe_path(@recipe), "post" do

      assert_select "input#recipe_name[name=?]", "recipe[name]"

      assert_select "input#recipe_url[name=?]", "recipe[url]"

      assert_select "textarea#recipe_instructions[name=?]", "recipe[instructions]"

      assert_select "input#recipe_picture_url[name=?]", "recipe[picture_url]"

      assert_select "input#recipe_menu_type[name=?]", "recipe[menu_type]"
    end
  end
end
