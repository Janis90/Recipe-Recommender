module EventsHelper
  def render_event_info_button(event)
    link_to "<i class='glyphicon glyphicon-info-sign'></i>".html_safe,  event_path(event), class: 'btn btn-info'
  end

  def render_event_edit_button(event)
    link_to "<i class='glyphicon glyphicon-pencil'></i>".html_safe, edit_event_path(event), class: 'btn btn-primary'
  end

  def render_event_destroy_button(event)
    link_to "<i class='glyphicon glyphicon-trash'></i>".html_safe, event, method: :delete, data: { confirm: t('helpers.prompts.delete', :name => event.title) }, class: 'btn btn-danger'
  end

  def render_not_participate_button(event)
    link_to  "<i class='glyphicon glyphicon-remove-sign'></i>".html_safe, decline_event_path(event), method: :delete, class: 'btn btn-warning'
  end

  def render_get_recommendations_button(event)
    link_to "Recommender: let's go!", show_recommendations_path(event), class: 'btn btn-success'
  end
end
