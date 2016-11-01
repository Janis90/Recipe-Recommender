class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend, only: %i(unfriend destroy)

  def index
    @friends = current_user.friends
  end

  def create
    friend = User.where(username: params[:user][:username]).first

    if friend.nil?
      redirect_to friendships_path, alert: t('friendships.alerts.not_exist')
    else
      # TOFIX - Due to used gem, it needs to be `friend.request(current_user)` instead of `current_user.request(friend)`.
      # If time allows it, fix it or remove the plugin to do it ourself for a better usecase and control over the application.
      friend.friend_request(current_user)
      redirect_to friendships_path, notice: t('friendships.notices.sent')
    end
  end

  def destroy
    if current_user.remove_friend(@friend)
      redirect_to friendships_path, notice: t('friendships.notices.removed')
    else
      redirect_to friendshipss_path, alert: t('friendships.alerts.not_unfriended')
    end
  end

  # accept a friend request
  def accept_friend
    friend = get_friend
    if current_user.pending_friends.include?(friend)
      current_user.accept_request(friend)
      redirect_to friendships_path, notice: t('friendships.notices.accepted')
    else
      redirect_to friendships_path, alert: t('friendships.alerts.no_friend_request')
    end
  end

  def decline_friend
    friend = get_friend
    if current_user.pending_friends.include?(friend)
       current_user.decline_request(friend)
       redirect_to friendships_path, notice: t('friendships.notices.declined')
    else
      flash[:error] = 'Friend could not be declined!'
      redirect_to friendships_path, alert: t('friendships.alerts.not_declined')

    end
  end

  private

  def set_friend
    friend = get_friend
    if current_user.friends_with?(friend)
      @friend = friend
    else
      redirect_to friendships_path, alert: t('friendships.alerts.not_friends', :friend => @friend.username)
    end
  end

  def get_friend
    User.find(params[:id])
  end
end
