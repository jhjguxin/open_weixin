module OpenWeixin
  module Config

    def self.app_id=(val)
      @@app_id = val
    end

    def self.app_id
      @@app_id
    end

    def self.app_secret=(val)
      @@app_secret = val
    end

    def self.app_secret
      @@app_secret
    end

    def self.redirect_uri=(val)
      @@redirect_uri = val
    end

    def self.redirect_uri
      @@redirect_uri
    end
  end
end
