# encoding: utf-8
#bellow code to initialize the BabyTime
OpenWeixinConfig = YAML.load_file("./spec/support/open_weixin.yml")["test"].symbolize_keys
OpenWeixin::Config.app_id = OpenWeixinConfig[:app_id]
OpenWeixin::Config.app_secret = OpenWeixinConfig[:app_secret]
OpenWeixin::Config.redirect_uri = OpenWeixinConfig[:redirect_uri]
