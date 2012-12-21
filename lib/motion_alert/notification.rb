module MotionAlert

  class Notification

    def initialize(image_path)
      @image_path = image_path
    end

    def recent_image
      @image_path
    end
  end
end
