#encoding: UTF-8
require 'spec_helper'
require 'motion_alert/notifiers/mail_notifier'
require 'mail'
require 'backports'


module MotionAlert::Notifiers

  describe "MailNotifier" do

    let(:recipients) do
      1.upto(5).map do
          FactoryGirl.generate(:email)
      end
    end

    let (:sender) do
      FactoryGirl.generate(:email)
    end
    
    let (:mail_subject) {"test subject"}
    let (:mail_message) {"test message"}

    describe "#from_options" do
      context "when some required options are missing" do
        it "should raise an error" do
          expect{MailNotifier.from_options(foor: "bar")}.to raise_error
        end
      end

      context "when all required options are given" do
        it "should return a MailNotifier object" do
          expect(MailNotifier.from_options(mail_text: mail_message, mail_subject: mail_subject, mail_to: recipients, mail_from: sender)).to be_a_kind_of MailNotifier
        end
      end
    end


    describe "#process" do
      include Mail::Matchers

      it "should send an email including the image given by the notification to the proper recipients" do
        notification = mock
        notification.should_receive(:recent_image).and_return(sample_image) 

        notifier = MailNotifier.new(recipients, sender, mail_subject, mail_message)

        Mail.defaults do
          delivery_method :test
        end

        notifier.process(notification)

        Mail.should have_sent_email
        Mail.should have_sent_email.from sender
        Mail.should have_sent_email.to recipients
        Mail.should have_sent_email.with_subject mail_subject
        
        mail = Mail::TestMailer.deliveries.first
        mail.parts[0].body.should eq mail_message
        mail.attachments[0].filename.should eq File.basename(sample_image)
        mail.attachments[0].body.should eq File.read(sample_image, encoding: "ASCII-8BIT")
      end

      def mock_mail
      end
    end

  end
end


