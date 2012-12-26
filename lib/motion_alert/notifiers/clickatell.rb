require 'net/https'

module MotionAlert::Notifiers

  # Send a SMS using the [ClickATell HTTP API](http://www.clickatell.com/apis-scripts/apis/http-s/) 
  class ClickATell
    attr_reader :user, :password, :api_id, :phone, :message

    API_URL = "https://api.clickatell.com/http/sendmsg?user=USER&password=PASSWORD&api_id=API_ID&to=PHONE&text=MESSAGE"
    REQUIRED_OPTIONS = [:user, :password, :api_id, :phone, :message]

    def self.from_options(opts)
      options = Hash.new.merge(opts).symbolize_keys
      missings = REQUIRED_OPTIONS - options.keys

      unless missings.empty?
        raise "The following required options are missing: #{missings.join(", ")}"
      end

      new(options[:user], options[:password], options[:api_id], options[:phone], options[:message])
    end

    # Initialize the notifier.
    # @param [String] user user to connect to the ClickATell HTTP API
    # @param [String] password password to connect to the ClickATell HTTP API
    # @param [String] api_id api id
    # @param [String] phone phone to number to send the SMS to
    # @param [String] message message of the SMS to send
    def initialize(user, password, api_id, phone, message)
      @user = user
      @password = password
      @api_id = api_id
      @phone = phone
      @message = message
    end

    # Process a notification, sending a SMS to the phone number given in the #initialize call.
    # @param [String] notification the notification object provided by the motion event (not used)
    def process(notification)
      url = API_URL.sub(/USER/, URI.escape(user)) \
                   .sub(/PASSWORD/, URI.escape(password)) \
                   .sub(/API_ID/, URI.escape(api_id)) \
                   .sub(/PHONE/, URI.escape(phone)) \
                   .sub(/MESSAGE/, URI.escape(message))

      uri = URI(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if ! response.body.match(/ID: [a-f0-9]+/)
        raise "The request to the ClickATell API failed (HTTP response code #{response.code}), with the following message: #{response.body}" 
      end
    end
  end
end
