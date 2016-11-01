module AllergiesHelper
  def render_allergy_edit_button(allergy)
    link_to "<i class='glyphicon glyphicon-pencil'></i>".html_safe,  edit_allergy_path(allergy), class: 'btn btn-info'
  end

  def render_allergy_destroy_button(allergy)
    link_to "<i class='glyphicon glyphicon-trash'></i>".html_safe, allergy, method: :delete, data: { confirm: t('helpers.prompts.delete', :name => allergy.name) }, class: 'btn btn-danger'
  end
end
