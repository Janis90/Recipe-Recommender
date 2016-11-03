module UsersHelper
  def render_user_into_button(user)
    link_to "<i class='glyphicon glyphicon-user'></i>".html_safe, user_path(user), class: 'btn btn-info'
  end

  def render_user_admin_button(user)
    if user.admin?
      link_to "<i class='glyphicon glyphicon-ok'></i>".html_safe, change_admin_status_user_path(user), method: :post, class: 'btn btn-success'
    else
      link_to "<i class='glyphicon glyphicon-remove'></i>".html_safe, change_admin_status_user_path(user), method: :post, class: 'btn btn-danger'
    end
  end
end
