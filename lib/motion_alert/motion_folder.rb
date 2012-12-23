module MotionAlert

  # Helper Class to analyse the content of the motion folder where
  # images and videos are stored.
  class MotionFolder

    #default time tolerance considered for the definition of "recent"
    TIME_TOLERANCE = 2

    attr_reader :folder_path

    def initialize(folder_path, options = nil)
      raise Errno::ENOENT.new("directory #{folder_path} does not exits") unless File.directory?(folder_path)
      @folder_path = folder_path
      @options = {}
      @options[:time_tolerance] = TIME_TOLERANCE
      @options.merge! options if options
    end

    def recent_image
      image = Dir["#{folder_path}/*.jpg"].select do |path|
        path.match /\d\d-\d{14}/
      end
      .sort do |a, b|
            ta = time_from_filename a
            tb = time_from_filename b
            tb <=> ta
      end
      .find do |image|
        (time_from_filename(image) - Time.now).abs < time_tolerance
      end
      
      return nil unless image

      File.join(folder_path, File.basename(image))
    end
  end

  private

  def time_from_filename(filename)
    m = filename.match /\d\d-(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/
    Time.mktime(*m[1..6])
  end

  def time_tolerance
    @options[:time_tolerance]
  end

end
