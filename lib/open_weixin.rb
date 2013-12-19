if defined?(Bundler)
  Bundler.setup
end

require 'active_support/all'
require "open_weixin/version"
require 'open_weixin/interface/base'
require 'open_weixin/interface/snsapi'
require 'open_weixin/client'
require 'open_weixin/access_token'
require 'open_weixin/config'
require 'open_weixin/error'
require 'open_weixin/strategy/auth_code.rb'
require 'open_weixin/strategy/signed_request.rb'
