## OpenWeixin
> base on weibo2, by francis

A Ruby wrapper for SA wrapper for 'open.weixin.qq.com' OAuth2 API.It is based on {OAuth2 gem}[https://github.com/intridea/oauth2], thanks for his hard-working.I have wrapped most of the APIs sina defined.Note that all of the privilege APIs haven't been tested yet, since I don't get the authorization to use it.

### Installation

  gem install open_weixin

### Usage Examples

Config your api_key, api_secret and redrect_uri somewhere like development.rb.

  OpenWeixin::Config.api_key = "1234567890"
  OpenWeixin::Config.api_secret = "somethinglooksstrageandhardtoremember"
  OpenWeixin::Config.redirect_uri = "http://www.example.com/callback"

Ok, now you are ready to enjoy it. OpenWeixin has provided several ways to get your access token, and you can easily get it using OpenWeixin.

1. The Authorization Code strategy with response_type set to code

  # get authorize_url
  client = OpenWeixin::Client.new
  client.auth_code.authorize_url
  # => "https://api.weibo.com/oauth2/authorize?response_type=code&client_id=1234567890&redirect_uri=http%3A%2F%2Fwww.example.com%2fcallback"

  # get token using authorization_code
  # OpenWeixin::Client.from_code is a shortcut for client.auth_code.get_token("authorization_code_value")
  client = OpenWeixin::Client.from_code("authorization_code_value")

2. The Authorization Code strategy with response_type set to token

  # get authorize_url with response_type set to token
  client = Weibo::Client.new
  client.auth_code.authorize_url(:response_type => "token")
  # => "https://api.weibo.com/oauth2/authorize?response_type=token&client_id=1234567890&redirect_uri=http%3A%2F%2Fwww.example.com%2fcallback"

  # get token from callback hash like this /callback#access_token=6874dd3766b35536abcb76a9e3a57867&expires_in=86400
  client = OpenWeixin::Client.from_hash(:access_token => "6874dd3766b35536abcb76a9e3a57867", :expires_in => 86400)

3. Refresh your token

Note that you could refresh your token only when you can get the refresh_token.


  client.refresh!

You can check if you are authorized by

  client.is_authorized?
  # => true

4. fetch userinfo

  def tqq_status_update(auth = nil, message = nil)
    if auth.present? and auth.provider.eql? "tqq"
      client = OpenWeixin::Client.from_hash(access_token: auth.access_token)
      message ||= "it's a test message ... by francis, from #{root_url}"
      #message ||= "it's a test message ... by francis, from #{app.root_url(host: "bbtang.com")}"
      clientip = Setting.server_ip
      clientip ||= "xxx.xxx.xxx.xxx"
      client.t.add(message, {clientip: Setting.server_ip, content: message, "openid" => auth.uid})
    end
  end


### API

You can find them in /lib/OpenWeixin/interface/.Note that all methods follow the patten of

  {resource}.{the_rest_path_joined_by_underline}(required_params, opts={})

So {/statuses/hot/comments_weekly}[http://open.weibo.com/wiki/2/statuses/hot/comments_weekly] will turn to

  statuses.hot_comments_weekly(opts={})

And {/friendships/friends/in_common}[http://open.weibo.com/wiki/2/friendships/friends/in_common] will turn to

  friendships.friends_in_common(uid, opts={})


### Copyright

Copyright (c) 2011 Francis Jiang. See LICENSE for details.
