require 'test_helper'
require 'minitest/autorun'

module Coolsms
  class TestSend < Minitest::Test
    def test_single
      msg = Coolsms::Message.new
      msg.text = '안녕, 세계 ㅎㅎ'
      result = msg.send(COOLSMS_TEST_RECEIVERS.first)
      assert_equal 1, result.body['success_count']
    end
  end
end
