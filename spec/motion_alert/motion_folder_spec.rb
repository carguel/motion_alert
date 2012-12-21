require 'spec_helper'
require 'motion_alert'
require 'motion_alert/motion_folder'

module MotionAlert

  describe "MotionFolder" do


    include MotionFolderFakeHelper

    describe "#recent_image" do
      it "should return the path of an image stored in the motion folder no more than 2 seconds ago" do
        mf = MotionFolder.new(motion_path)
        mf.recent_image.should == path_of_last_image
      end

      it "should return nothing if the last image was stored more than 1 second ago" do
        mf = MotionFolder.new(motion_path, time_tolerance: 1)
        sleep 2
        expect(mf.recent_image).to be_nil
      end

      it "should return the path of the image that has just been stored in the motion folder" do
        mf = MotionFolder.new(motion_path, time_tolerance: 5)
        sleep 2
        add_image
        expect(mf.recent_image).to eq path_of_last_image
      end

    end
  end
end

