module MotionAlert
  class Event
    
    attr_reader :motion_folder, :mail_to, :mail_from, :subject, :message, :motion_folder

    def initialize(motion_folder)
      @motion_folder = motion_folder
    end

    def register(notifier)
      (@notifiers ||= []) << notifier
    end

    def start
      event=self
      notification = Notification.new(motion_folder.recent_image)
      @notifiers.each do |notifier|
        notifier.process notification
      end
    end

  end
end
