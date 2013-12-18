require "spec_helper"

describe OpenWeixin::Client do
  let(:client) { OpenWeixin::Client.new }

  context "#initialize config" do
    it "should have correct site" do
      client.site.should eq("https://open.weixin.qq.com/")
    end

    it "should have correct authorize url" do
      client.options[:authorize_url].should eq('/connect/oauth2/authorize')
    end

    it "should have correct token url" do
      client.options[:token_url].should eq('/sns/oauth2/access_token')
    end
  end
end
