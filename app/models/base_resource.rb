require 'rubygems'
require 'active_resource'

class BaseResource < ActiveResource::Base
  self.site = Settings.api.site
  self.user = ENV['API_USER']
  self.password = ENV['API_PASSWORD']

  class << self
    def find(scope, options = {})
      super(scope, options.deep_merge(params: { user_uid: user_uid }))
    end

    def user_uid=(uid)
      Thread.current[:user_uid] = uid
    end

    def user_uid
      Thread.current[:user_uid]
    end
  end

  def initialize(*args)
    super.tap do |resource|
      resource.prefix_options[:user_uid] = BaseResource.user_uid
    end
  end

  def update_attributes(options)
    super(options.merge(user_uid: BaseResource.user_uid))
  end
end
