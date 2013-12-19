require "spec_helper"

describe OpenWeixin::Interface::Snsapi do
  let(:client) do
    OpenWeixin::Client.from_hash(:access_token => "ACCESS_TOKEN", :expires_in => 7200) do |builder|
      builder.request :url_encoded
      builder.adapter :test do |stub|
        stub.get('/sns/userinfo?scope=snsapi_base&openid=12341432134&access_token=ACCESS_TOKEN') { [200, {}, user_info] }
      end
    end
  end

  let(:user_info) do
    MultiJson.encode({
      openid: "OPENID",
      nickname: "NICKNAME",
      sex: "1",
      province: "PROVINCE",
      city: "CITY"
    })
  end

  let(:snsapi) do
    OpenWeixin::Interface::Snsapi.new(client)
  end

=begin
  let(:snsapi) do
   stub_request(:get, '/sns/userinfo').
     with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
     to_return(:status => 200, :body => user_info.to_json, :headers => {})
  end
  let(:snsapi) do
    OpenWeixin::Interface::Snsapi.new(client) do |builder|
      builder.request :url_encoded
      builder.adapter :test do |stub|
        stub.get('/sns/userinfo') { [200, {}, user_info] }
      end
    end
  end
=end

  context "#userinfo" do
    it "return user info"do
      expect(snsapi.userinfo.body).to eq(user_info)
    end
  end
end
