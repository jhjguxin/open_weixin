# encoding: utf-8
module OpenWeixin
  module Interface

    # Users API
    #
    # @see http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3_V2#.E7.94.A8.E6.88.B7
    class Snsapi < Base

      # 获取用户基本信息 [Privilege]
      # @param [Hash] opts
      # @option opts [int64] :uid 需要获取基本信息的用户UID，默认为当前登录用户
      #
      # @see http://mp.weixin.qq.com/wiki/index.php?title=%E7%BD%91%E9%A1%B5%E6%8E%88%E6%9D%83%E8%8E%B7%E5%8F%96%E7%94%A8%E6%88%B7%E5%9F%BA%E6%9C%AC%E4%BF%A1%E6%81%AF
      # https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&scope=snsapi_userinfo
      def userinfo(opts = {})
        opts[:scope] ||= 'snsapi_base'
        get 'sns/userinfo', :params => opts
      end

    end
  end
end
