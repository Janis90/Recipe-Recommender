require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do

  describe "anonymous user" do
    before :each do
      # This simulates an anonymous user
      login_with nil
    end

    it "should be redirected to signin" do
      get :index
      expect( response ).to redirect_to( new_user_session_path )
    end

    it "should let a user see all friends" do
      login_with create( :user )
      get :index
      expect( response ).to render_template( :index )
    end
  end

  describe 'create a friendship between 2 valid friends' do
    let!(:user_1) { FactoryGirl.create(:user_valid_1) }
    let!(:user_2) { FactoryGirl.create(:user_valid_2) }

    context 'user1 and user2 are not friends yet' do
      before(:each) do
        sign_in user_1
      end

      it 'should change the number of pending friends' do
        expect { post :create, { user: { username: user_2.username } } }.to change(user_2.pending_friends, :count).by(1)
      end

      it 'should change the number of friend requests' do
        expect { post :create, { user: { username: user_2.username } } }.to change(user_1.requested_friends, :count).by(1)
      end

      #it 'should change the number of friends' do
        #user_2.friend_request(user_1)

        #expect { post :accept_friend, user: user_2 }.to change(user_1.friends, :count).by(1)
      #end

      #it 'should not change the number of friends' do
        #user_2.friend_request(user_1)

        #expect { post :decline_friend, user: user_2 }.to change(user_1.friends, :count).by(0)
      #end
    end
  end

end
