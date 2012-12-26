module MotionAlert::CLI

  # Helper class used by the CLI
  class Helper

    # Build a hash from the hash of the CLI options, keeping only keys related to the given notifier and
    # removing the notifier prefix from all kept keys. It is expected that all the keys related to a notifier start with the following pattern "#{notifier}_".
    #
    #
    # @param [String] notifier the notifier
    # @param [String] options hash of the CLI options
    # @return [Hash<String, String>] a hash with only the entries from the options hash related to the notifier
    #   The prefix of the notifier is removed  from all keys of this hash.
    def self.options_for_notifier(notifier, options)
      options.inject(Hash.new) do |hash, (k, v)|
        if k.to_s.start_with? notifier
          hash[k.to_s.sub(/\A#{notifier}_/, "")] = v
        end
        hash
      end
    end
  end
end
