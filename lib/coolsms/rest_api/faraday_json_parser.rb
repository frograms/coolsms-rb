FaradayMiddleware::ParseJson.dependency do
  require 'oj' unless defined?(::Oj)
end

FaradayMiddleware::ParseJson.define_parser do |body, parser_options|
  ::Oj.load(body || '', parser_options)
end
