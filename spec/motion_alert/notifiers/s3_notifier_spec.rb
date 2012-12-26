require 'spec_helper'
require 'motion_alert/notification'
require 'motion_alert/notifiers/s3_notifier'

module MotionAlert::Notifiers

  describe S3Notifier do

    describe "#from_options" do

      context "when a required option is missing" do
        it "should raise an error" do
          expect {S3Notifier.from_options(foo: "bar")}.to raise_error
        end
      end

      context "when all required options are given" do
        it "should return a S3Notifier object" do
          expect(S3Notifier.from_options(aws_access_key: "access",
                                          aws_secret_key: "secret",
                                          bucket_name: "bucket"
                                         )
                 ).to be_a_kind_of S3Notifier
        end
      end

      context "when all required and optional options are given" do
        it "should return a S3Notifier object based on all provided options" do
          path = "my_path/my_subpath"
          s3 = S3Notifier.from_options(aws_access_key: "access",
                                          aws_secret_key: "secret",
                                          bucket_name: "bucket",
                                          path: path
                                         )
          expect(s3).to be_a_kind_of S3Notifier
          expect(s3.path).to eq path
        end
      end
    end


    describe "#process" do
      include S3Helper

      let(:aws_access_key) {"ACCESS"}
      let(:aws_secret_key) {"SECRET"}
      let(:aws_bucket) {"bucket"}
      let(:aws_bucket_path) {"images"}

      before(:each) do 
        fakes3.start
      end
      
      after(:each) do
        fakes3.stop
      end

      context "when an image is associated to the notification" do
        it "should save the image included in the notification on S3" do
          notifier = S3Notifier.new(aws_access_key, aws_secret_key, aws_bucket, aws_bucket_path)
          notification = Notification.new(sample_image)

          notifier.process(notification)

          key = "#{aws_bucket_path}/#{File.basename(sample_image)}"
          expect(fakes3.exists?(aws_bucket, key)).to be_true
        end
      end

      context "when no image is associated to the notification" do
        it "should do nothing" do
          notifier = S3Notifier.new(aws_access_key, aws_secret_key, aws_bucket, aws_bucket_path)
          notification = Notification.new(nil)

          notifier.process(notification)

          expect(fakes3.objects_in_bucket(aws_bucket).count).to eq 0
        end
      end
    end
  end
end
      
