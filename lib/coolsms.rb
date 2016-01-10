require 'logger'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/class/attribute_accessors'
require 'oj'
require 'faraday'
require 'faraday_middleware'
require 'coaster'
require 'awesome_print'

module Coolsms
  mattr_accessor :api_key, :api_secret,
                 :default_from

  mattr_accessor :url
  @@url = 'https://api.coolsms.co.kr'

  mattr_accessor :logger
  @@logger = Logger.new('log/sms.log')

  NUMBER_STRIP_REGEX = /[^\d]/

  class << self
    def number_strip(str)
      str.gsub(NUMBER_STRIP_REGEX, '')
    end

    def configure
      yield(self)
    end
  end
end

require 'coolsms/errors'
require 'coolsms/rest_api'
require 'coolsms/message'
