require 'spec_helper'
require 'motion_alert/notifiers/clickatell'
require 'net/https'

module MotionAlert::Notifiers

  describe ClickATell do

    let(:user) {"user"}
    let(:password) {"password"}
    let(:api_id) {"api_id"}
    let(:message) {"my message"}
    let(:phone) {"09999999"}

    describe "from_options" do

      context "when required options are missing" do 

        it "should raise an error" do
          expect{ClickATell.from_options(foo: "bar")}.to raise_error
        end

      end

      context "when all required options are given" do 
        subject {ClickATell.from_options(user: user, password: password, api_id: api_id, phone: phone, message: message)}
        it{should be_a_kind_of ClickATell}
        its(:user) {should eq user}
        its(:password) {should eq password}
        its(:api_id) {should eq api_id}
        its(:phone) {should eq phone}
        its(:message) {should eq message}
      end
    end

    describe "#process" do
      let(:url) {"https://api.clickatell.com/http/sendmsg?user=#{URI.escape(user)}&password=#{URI.escape(password)}&api_id=#{URI.escape(api_id)}&to=#{URI.escape(phone)}&text=#{URI.escape(message)}"}
      let(:notification) {mock}
      let(:response_mock) {mock}

      subject {ClickATell.new(user, password, api_id, phone, message)}

      before(:each) do
        # mock HTTPS request
        uri = URI(url)
        http_mock = mock
        request_mock = mock
        Net::HTTP.should_receive(:new).with(uri.host, uri.port).and_return(http_mock)
        http_mock.should_receive(:request).with(request_mock).and_return(response_mock)
        http_mock.should_receive(:use_ssl=).with(true)
        http_mock.should_receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)

        Net::HTTP::Get.should_receive(:new).with(URI(uri).request_uri).and_return(request_mock)
       
      end

      context "when the access parameters are valid" do
        it "should invoke the ClickATell HTTPS API" do
          mock_response_with_code_and_body("200", "ID: 96bdcc8fb1ed2a53fc12274aca0b726f")
          subject.process(notification)
        end
      end

      context "when the access parameters are not valid" do
        it "should invoke the ClickATell HTTPS API and raise an error" do
          mock_response_with_code_and_body("200", "ERR: 001, Authentication failed")
          expect{subject.process(notification)}.to raise_error
        end
      end

      # Mock the response returned by the Net::HTTP.request invokation.
      # @param [String] code the HTTP response code
      # @param [String body the body of the response
      def mock_response_with_code_and_body(code, body)
        response_mock.stub(:code) {code}
        response_mock.should_receive(:body).at_least(1).times.and_return(body)
      end
    end
  end
end
