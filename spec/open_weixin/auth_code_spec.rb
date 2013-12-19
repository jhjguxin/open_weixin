require "spec_helper"

describe OpenWeixin::Strategy::AuthCode do
  let(:code) {'sushi'}
  let(:json_token) { {:expires_in => 7200, :access_token => 'salmon', :refresh_token => 'trout', :extra_param => 'steve'} }

  let(:client) do
    OpenWeixin::Client.new() do |builder|
      builder.adapter :test do |stub|
        stub.get("/sns/oauth2/access_token") do |env|
          if (scope = env[:params]['scope']).present?
            json_token.merge!({scope: scope})
          end

          case @mode
            when "json"
              [200, {'Content-Type' => 'application/json'}, MultiJson.encode(json_token)]
          end
        end
        stub.post('/sns/oauth2/access_token') do |env|
          if (scope = ActiveSupport::HashWithIndifferentAccess.new(env[:body])['scope']).present?
            json_token.merge!({scope: scope})
          end

          case @mode
            when "json"
              [200, {'Content-Type' => 'application/json'}, MultiJson.encode(json_token)]
          end
        end
      end
    end
  end

  subject {client.auth_code}

  describe "#authorize_url" do
    it "includes the client_id" do
      expect(subject.authorize_url).to include('client_id=12341432134')
    end

    it "includes the type" do
      expect(subject.authorize_url).to include('response_type=code')
    end

    it "includes passed in options" do
      cb = 'http://myserver.local/oauth/callback'
      expect(subject.authorize_url(:redirect_uri => cb)).to include("redirect_uri=#{Rack::Utils.escape(cb)}")
    end
  end

  %w(json).each do |mode|
    [:get, :post].each do |verb|
      describe "#get_token (#{mode}, access_token_method=#{verb}" do
        before do
          @mode = mode
          client.options[:token_method] = verb
          @access = subject.get_token(code)
        end

        it "returns AccessToken with same Client" do
          expect(@access.client).to eq(client)
        end

        it "returns AccessToken with #token" do
          expect(@access.token).to eq('salmon')
        end

        it "returns AccessToken with #refresh_token" do
          expect(@access.refresh_token).to eq('trout')
        end

        it "returns AccessToken with #expires_in" do
          expect(@access.expires_in).to eq(7200)
        end

        it "returns AccessToken with params accessible via []" do
          expect(@access['extra_param']).to eq('steve')
        end

        it "returns AccessToken with #code eql snsapi_userinfo" do
          expect(subject.get_token(code, {scope: "snsapi_userinfo"})['scope']).to eq("snsapi_userinfo")
        end
      end
    end
  end
end
