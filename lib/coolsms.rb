require 'logger'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/array/extract_options'
require 'active_support/values/time_zone'
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

  mattr_accessor :faraday_adapter

  NUMBER_STRIP_REGEX = /[^\d]/
  TIMEZONE = ActiveSupport::TimeZone.new('Seoul')

  class << self
    def number_strip(str)
      str.gsub(NUMBER_STRIP_REGEX, '')
    end

    def configure
      yield(self)
    end

    def message(text, *to)
      options = to.extract_options!
      from = options[:from] || default_from
      msg = Coolsms::Message.new(text: text, from: from)
      if block_given?
        yield(msg)
      else
        msg.send(*to)
      end
      msg
    end
  end
end

require 'coolsms/errors'
require 'coolsms/rest_api'
require 'coolsms/base'
require 'coolsms/finder'
require 'coolsms/message'
require 'coolsms/group'
