require 'aws-sdk'
require 'backports'

module MotionAlert::Notifiers

  # Notifier that pushes the file associated to a notification to an S3 bucket
  class S3Notifier

    attr_reader :path

    REQUIRED_OPTIONS = [:aws_access_key, :aws_secret_key, :s3_bucket_name]

    def self.from_options(opts)
      options = Hash.new().merge(opts)
      options.symbolize_keys!

      missings = REQUIRED_OPTIONS - options.keys

      unless missings.empty?
        raise "the following parameters are missing: #{missings.join ","}"
      end

      new(options[:aws_access_key], options[:aws_secret_key], options[:bucket_name], options[:s3_path])
    end

    # Instanciate a notifier
    # @param [String] accesskey AWS Access Key
    # @param [String] secret_key AWS Secret key
    # @param [String] bucket_name name of the bucket where the files will be stored
    # @param [String] path optional sub-path under the bucket where the files will be stored  
    def initialize(access_key, secret_key, bucket_name, path="/")
      @access_key = access_key
      @secret_key = secret_key
      @bucket_name = bucket_name
      @path = path
    end

    # Store the file associated to the notification to S3
    # @param [MotionAlert::Notification] notification notification by a MotionAlert hook
    def process(notification)
      return if notification.recent_image.nil?
      image_name = File.basename(notification.recent_image)
      obj = bucket.objects["#{@path}/#{image_name}"]
      obj.write(Pathname.new(notification.recent_image))
    end

    private

    # Return the S3 object related to the initialisation parameters
    # @return [AWS::S3] the S3 object
    def s3
      @s3 ||= AWS::S3.new(access_key_id: @access_key, secret_access_key: @secret_key)
    end

    # Return the bucket object related to the bucket_name initialisation parameter
    # @return [AWS::S3::Bucket] the bucket object
    def bucket
      @bucket ||= s3.buckets[@bucket_name]
    end
  end
end
