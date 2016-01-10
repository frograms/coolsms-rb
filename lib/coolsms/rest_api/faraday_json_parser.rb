FaradayMiddleware::ParseJson.dependency do
  require 'oj' unless defined?(::Oj)
end

FaradayMiddleware::ParseJson.define_parser do |body|
  ::Oj.load(body || '')
end
