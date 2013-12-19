require "spec_helper"

VERBS = [:get, :post]

describe OpenWeixin::AccessToken do
  let(:token) {'ACCESS_TOKEN'}
  let(:token_body) {MultiJson.encode(:access_token => 'ACCESS_TOKEN', :expires_in => 7200, :refresh_token => 'REFRESH_TOKEN')}
  let(:refresh_body) {MultiJson.encode(:access_token => 'ACCESS_TOKEN', :expires_in => 7200, :refresh_token => 'REFRESH_TOKEN')}
  let(:client) do
    OpenWeixin::Client.new do |builder|
      builder.request :url_encoded
      builder.adapter :test do |stub|
        #VERBS.each do |verb|
        #  stub.send(verb, '/sns/oauth2/access_token') {|env| [200, {}, env[:request_headers]['Authorization']]}
        #end
        VERBS.each do |verb|
          stub.send(verb, '/sns/oauth2/access_token') {|env| [200, {'Content-Type' => 'application/json'}, token_body]}
          stub.send(verb, '/sns/oauth2/refresh_token') {|env| [200, {'Content-Type' => 'application/json'}, refresh_body]}
        end
        # stub.post('/sns/oauth2/access_token') {|env| [200, {'Content-Type' => 'application/json'}, refresh_body]}
      end
    end
  end

  subject {OpenWeixin::AccessToken.new(client, token)}

  describe "#initialize" do
    it "assigns client and token" do
      expect(subject.client).to eq(client)
      expect(subject.token).to  eq(token)
    end

    it "assigns extra params" do
      target = OpenWeixin::AccessToken.new(client, token, 'foo' => 'bar')
      expect(target.params).to include('foo')
      expect(target.params['foo']).to eq('bar')
    end

    def assert_initialized_token(target)
      expect(target.token).to eq(token)
      expect(target).to be_expires
      expect(target.params.keys).to include('foo')
      expect(target.params['foo']).to eq('bar')
    end

    it "initializes with a Hash" do
      hash = {:access_token => token, :expires_in => Time.now.to_i + 200, 'foo' => 'bar'}
      target = OpenWeixin::AccessToken.from_hash(client, hash)
      assert_initialized_token(target)
    end

    it "initializes with a string expires_in" do
      hash = {:access_token => token, :expires_in => '1361396829', 'foo' => 'bar'}
      target = OpenWeixin::AccessToken.from_hash(client, hash)
      assert_initialized_token(target)
      expect(target.expires_in).to be_a(Integer)
    end
  end

  describe "#request" do

    context ":mode => :body" do
      before do
        subject.options[:mode] = :body
      end

      VERBS.each do |verb|
        it "sends the token in the Authorization header for a #{verb.to_s.upcase} request" do
          expect(subject.post('/sns/oauth2/access_token').body).to include(token)
        end
      end
    end
  end

  describe "#expires?" do
    it "is false if there is no expires_at" do
      expect(OpenWeixin::AccessToken.new(client, token)).not_to be_expires
    end

    it "is true if there is an expires_in" do
      expect(OpenWeixin::AccessToken.new(client, token, :refresh_token => 'REFRESH_TOKEN', :expires_in => 600)).to be_expires
    end

  end

  describe "#expired?" do
    it "is false if there is no expires_in or expires_at" do
      expect(OpenWeixin::AccessToken.new(client, token)).not_to be_expired
    end

    it "is false if expires_in is in the future" do
      expect(OpenWeixin::AccessToken.new(client, token, :refresh_token => 'REFRESH_TOKEN', :expires_in => 10800)).not_to be_expired
    end

    it "is true if expires_at is in the past" do
      access = OpenWeixin::AccessToken.new(client, token, :refresh_token => 'REFRESH_TOKEN', :expires_in => 600)
      @now = Time.now + 10800
      allow(Time).to receive(:now).and_return(@now)
      expect(access).to be_expired
    end

  end

  describe "#refresh!" do
    let(:access) {
      OpenWeixin::AccessToken.new(client, token, :refresh_token  => 'REFRESH_TOKEN',
                                     :expires_in     => 7200,
                                     :param_name     => 'o_param')
    }

    it "returns a refresh token with appropriate values carried over" do
      refreshed = access.refresh!
      expect(access.client).to eq(refreshed.client)
      expect(access.options[:param_name]).to eq(refreshed.options[:param_name])
    end

    context "with a nil refresh_token in the response" do
      let(:refresh_body) { MultiJson.encode(:access_token => 'refreshed_foo', :expires_in => 600, :refresh_token => nil) }

      it "copies the refresh_token from the original token" do
        refreshed = access.refresh!

        expect(refreshed.refresh_token).to eq(access.refresh_token)
      end
    end
  end

  describe '#to_hash' do
    it 'return a hash equals to the hash used to initialize access token' do
      hash = {:access_token => token, :refresh_token => 'foobar', :expires_at => Time.now.to_i + 200, 'foo' => 'bar'}
      access_token = OpenWeixin::AccessToken.from_hash(client, hash.dup)
      expect(access_token.to_hash).to eq(hash)
    end
  end
end
