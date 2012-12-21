require 'spec_helper'
require 'motion_alert/notification'

module MotionAlert
  describe "Notification" do

    let(:image_path) {"path/to/image"}

    it "should allow to be instanciated with an image path" do
      Notification.new(image_path)
    end

    describe "#recent_image" do

      it "should send the image path" do
        notification = Notification.new(image_path)
        expect(notification.recent_image).to eq image_path
      end

    end
  end
end

