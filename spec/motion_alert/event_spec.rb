require 'spec_helper'
require 'motion_alert'
require 'motion_alert/event'
require 'mail'

module MotionAlert
  describe "Event" do
    describe "#start" do

      it "should build a notification and send it to all registered notifiers" do
        folder = mock
        image = "new_image"

        folder.should_receive(:recent_image).and_return(image)

        notification = mock
        Notification.should_receive(:new).and_return(notification)

        notifier = mock
        notifier.should_receive(:process).with(notification)

        event = Event.new(folder)
        event.register(notifier) 

        event.start

      end
    end

  end
end
