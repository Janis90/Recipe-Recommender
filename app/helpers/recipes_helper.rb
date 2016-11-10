module RecipesHelper
  #if current_user is the creator -> edit-button else ->add-button
  def render_edit_or_add_button(recipe)
    if recipe.recipe_creator_id == current_user.id
      link_to "<i class='gglyphicon glyphicon-pencil'></i>".html_safe, edit_recipe_path(recipe), class: 'btn btn-info btn-xs'
    else
      link_to "<i class='glyphicon glyphicon-plus'></i>".html_safe, add_recipe_path(recipe), class: 'btn btn-success btn-xs', method: :post
    end
  end
end
