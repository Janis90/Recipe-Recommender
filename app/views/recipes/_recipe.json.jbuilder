json.extract! recipe, :id, :name, :url, :instructions, :picture_url, :menu_type, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)