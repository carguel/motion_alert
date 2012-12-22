require 'spec_helper'
require 'motion_alert/notification'
require 'motion_alert/notifiers/s3_notifier'

module MotionAlert::Notifiers

  describe S3Notifier do

    describe "#process" do
      include S3Helper

      let(:aws_access_key) {"ACCESS"}
      let(:aws_secret_key) {"SECRET"}
      let(:aws_bucket) {"BUCKET"}
      let(:aws_bucket_path) {"images"}

      before(:each) do 
        fakes3.start
      end
      
      after(:each) do
        fakes3.stop
      end

      it "should save the image included in the notification on S3" do
        notifier = S3Notifier.new(aws_access_key, aws_secret_key, aws_bucket, aws_bucket_path)
        notification = Notification.new(sample_image)

        notifier.process(notification)

        key = "#{aws_bucket_path}/#{File.basename(sample_image)}"
        expect(fakes3.exists?(aws_bucket, key)).to be_true
      end
    end
  end
end
      
