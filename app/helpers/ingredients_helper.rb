module IngredientsHelper
  def render_ingredient_edit_button(ingredient)
    link_to "<i class='glyphicon glyphicon-pencil'></i>".html_safe,  edit_ingredient_path(ingredient), class: 'btn btn-info'
  end

  def render_ingredient_destroy_button(ingredient)
        link_to "<i class='glyphicon glyphicon-trash'></i>".html_safe, ingredient, method: :delete, data: { confirm: t('helpers.prompts.delete', :name => ingredient.name) }, class: 'btn btn-danger'
  end

  def render_circle(is_foodcategory)
    if is_foodcategory
      '<p class="text-center"><span class="badge badge-success">Yes</span></p>'.html_safe
    else
      '<p class="text-center"><span class="badge badge-error">No</span></p>'.html_safe
    end
  end
end
