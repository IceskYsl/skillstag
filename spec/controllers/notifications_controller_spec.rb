require 'spec_helper'

describe NotificationsController do
  let(:user) { Factory :user }
  describe "#index" do
    it "should show notifications" do
      sign_in user
      Factory :notification_mention, :user => user, :mentionable => Factory(:reply)
      Factory :notification_topic_reply, :user => user
      get :index
      response.should render_template(:index)
    end
  end

  describe "#destroy" do
    it "should destroy notification" do
      sign_in user
      notification = Factory :notification_mention, :user => user, :mentionable => Factory(:reply)

      lambda do
        delete :destroy, :id => notification
      end.should change(user.notifications, :count)
    end
  end

  describe "#clear" do
    it "should clear all" do
      sign_in user
      3.times{ Factory :notification_mention, :user => user, :mentionable => Factory(:reply) }

      post :clear
      user.notifications.unread.count.should == 0
    end
  end
end
