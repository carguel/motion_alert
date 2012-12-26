require 'mail'
require 'backports'

module MotionAlert::Notifiers
  class MailNotifier

    attr_reader :from, :recipients, :subject, :message

    REQUIRED_OPTIONS = [:subject, :text, :from, :to] 

    def self.from_options(opts)
      options = Hash.new.merge(opts).symbolize_keys
      missings = REQUIRED_OPTIONS - options.keys
      unless missings.empty?
        raise "The following required options are missing: #{missings.join(",")}"
      end
      MailNotifier.new(options[:to], options[:from], options[:subject], options[:text])
    end

    def initialize(recipients, from, subject, message)
      @recipients = recipients
      @from = from
      @subject = subject
      @message = message

      Mail.defaults do
        delivery_method :smtp, :enable_starttls_auto => false
      end

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
