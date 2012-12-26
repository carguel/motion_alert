require 'spec_helper'
require 'motion_alert/cli/helper'


module MotionAlert::CLI

  describe Helper do

    describe "#options_for_notifier" do
      
      it "should return only the options related to the given notifier, removing the notifier prefix of all keys" do
        options = {ntf_opt1: 1, ntf_opt2: 2, foo: "bar"}

        opts = MotionAlert::CLI::Helper.options_for_notifier("ntf", options)
        expect(opts).to have_key "opt1"
        expect(opts).to have_key "opt2"
        expect(opts).to have(2).items
      end
    end
    
  end
end
