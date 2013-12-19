require "spec_helper"

describe OpenWeixin::Config do
  let(:config) { OpenWeixin::Config }

  context "#initialize config" do
    it "should have correct app_id" do
      config.app_id.should eq("12341432134")
    end

    it "should have correct app_secret" do
      config.app_secret.should eq('app_secret')
    end

    it "should have correct redirect_uri" do
      config.redirect_uri.should eq('http://www.example.com/callback')
    end
  end
end
