require "spec_helper"

describe OpenWeixin::Client do
  let(:client) { OpenWeixin::Client.new }

  let(:access_token) { double(:openid => "open_id", :access_token => "access_token") }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', :parsed => parsed_response) }

  before(:each) do
    client.stub(:access_token).and_return(access_token)
  end

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

  context "#from_code" do
    let(:code) {'sushi'}
    let(:json_token) {MultiJson.encode(:expires_in => 7200, :access_token => 'salmon', :refresh_token => 'trout', :extra_param => 'steve')}

    let(:client_from_code) do
      OpenWeixin::Client.from_code(code) do |builder|
        builder.request :url_encoded
        builder.adapter :test do |stub|
          stub.get("/sns/oauth2/access_token") do |env|
             [200, {'Content-Type' => 'application/json'}, json_token]
          end
          stub.post('/sns/oauth2/access_token') do |env|
              [200, {'Content-Type' => 'application/json'}, json_token]
          end
        end
      end
    end


    it "returns AccessToken with #token" do
      expect(client_from_code.token.token).to eq('salmon')
    end
  end
end
