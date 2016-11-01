module FriendshipsHelper
  def render_unfriend_button(friend)
    link_to "<i class='glyphicon glyphicon-remove-circle'></i>".html_safe, friendship_path(friend), method: :delete, class: 'btn btn-danger'
  end

  def render_friend_into_button(friend)
     link_to "<i class='glyphicon glyphicon-user'></i>".html_safe, user_path(friend), class: 'btn btn-info'
  end

  def render_friend_accept_button(friend)
     link_to "<i class='glyphicon glyphicon-ok'></i>".html_safe, accept_friend_friendship_path(current_user, friend), method: :post, class: 'btn btn-success'
  end

  def render_friend_decline_button(friend)
     link_to "<i class='glyphicon glyphicon-remove'></i>".html_safe, decline_friend_friendship_path(current_user, friend), method: :post, class: 'btn btn-danger'
  end

  #This functions retun all links that are associated with friends
  #It is needed so that 'friends' is activated in the header by friends or friend
  def friends_path_collection
    friend_path = [friend_path, friendships_path]
  end

end
