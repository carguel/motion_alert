require 'spec_helper'
require 'motion_alert/notifiers/mail_notifier'
require 'mail'

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

    subject {MailNotifier.new(recipients, sender, mail_subject, mail_message)}
  
    describe "#process" do
      it "should send an email including the image given by the notification to the proper recipients" do
        notification = mock
        notification.should_receive(:recent_image) 

        mail = mock
        mail.should_receive(:to).with(recipients)
        mail.should_receive(:from).with(sender)
        mail.should_receive(:subject).with(mail_subject)

        text_part = mock()
        text_part.should_receive(:body).with(mail_message)
        text_part.should_receive(:content_type)
        
        mail.should_receive(:text_part) do |&arg|
          text_part.instance_eval(&arg)
        end


        Mail.should_receive(:deliver) do |&arg|
          mail.instance_eval(&arg)  
        end

        subject.process(notification)
      end
    end

  end
end


