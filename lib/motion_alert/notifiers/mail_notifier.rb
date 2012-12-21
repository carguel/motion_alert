module MotionAlert::Notifiers
  class MailNotifier

    attr_reader :from, :recipients, :subject, :message

    def initialize(recipients, from, subject, message)
      @recipients = recipients
      @from = from
      @subject = subject
      @message = message
    end

    def process(notification)
      recent_image = notification.recent_image

      notifier = self
      Mail.deliver do
        from    notifier.from 
        to      notifier.recipients
        subject notifier.subject

        text_part do
          content_type 'text/plain; charset=UTF-8'
          body    notifier.message
        end
        add_file recent_image if recent_image
      end

    end

  end
end
