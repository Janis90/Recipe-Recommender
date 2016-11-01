module ApplicationHelper
  #should be used like: class="<%= is_active?(new_user_session_path) %>" inside li for header items
  def is_active?(link_paths)
    is_active = false

    if link_paths.is_a? String
      if current_page?(link_paths)
        is_active = true
      end
    else
      link_paths.each do |link|
        if current_page?(link)
          is_active = true
          break
        end
      end
    end
    is_active ? 'active' : ''
  end

  # checks if the current user has pending friend requests
  # if so: put a green badge
  # if not: hide badge
  def render_badge
    current_user.pending_friends.count > 0 ? 'badge badge-success' : 'hide'
  end
end


