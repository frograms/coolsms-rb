module Coolsms
  class Base
    attr_accessor :attributes, :retrieved
    attr_reader :response

    def retrieve
      self
    ensure
      @retrieved = true
    end

    def [](key)
      value = attributes[key]
      if value.nil? && !retrieved
        retrieve
        attributes[key]
      else
        value
      end
    end

    def id
      attributes[:id]
    end

    def refresh!
      @attributes = {id: attributes[:id]}
      @retrieved = false
      retrieve
    end
  end
end
