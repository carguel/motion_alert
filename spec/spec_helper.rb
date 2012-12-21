require 'rspec'
require 'factory_girl'
require 'motion_alert/version'

FactoryGirl.find_definitions

include MotionAlert

#This module mocks up a motion folder and provides helper
#methods to interact with this folder
module MotionFolderFakeHelper

  # Return the name of the last image created
  # @return the name of the last image created in the motion folder
  def last_image
    @last_image 
  end

  # Return the path of the last image created
  # @return [String] the path of the last image added in the motion folder
  def path_of_last_image
    File.join(motion_path, last_image)
  end

  # Return the path of the faked motion folder
  # @return [String] the path of the motion folder
  def motion_path
    "./motion/"
  end

  # Initialize the faked motion folder adding some files
  def init_folder
    FakeFS.activate!

    FileUtils.mkdir(motion_path)
    #initialize the folder
    ["01-20121212223521-02.jpg", 
     "01-20121212223521-03.jpg", 
     "01-20121212223521-04.jpg"].each do |image|
       touch_file image
     end

     add_image
  end

  # Add an image in the motion with the current timestamp
  def add_image
    @last_image = Time.now.strftime("00-%Y%m%d%H%M%S-05.jpg") 
    touch_file @last_image
  end


  # Remove the motion folder
  def clean_folder
    FileUtils.rm_r(motion_path)
    FakeFS.deactivate!
  end

  # Add the before and after rspec hooks when the module is included
  def self.included(mod)
    require 'fakefs/safe'


    mod.instance_eval do
    before(:each) do
      init_folder
    end

    after(:each) do
      clean_folder
    end
    end


  end

  private 

  # Create a file in the faked motion folder
  # @param [String] filename name of the file to create (relative path from the motion folder path)
  def touch_file(filename)
       FileUtils.touch("#{motion_path}/#{filename}")
  end
end
