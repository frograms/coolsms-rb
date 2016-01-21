require 'test_helper'
require 'minitest/autorun'

module Coolsms
  class TestSend < Minitest::Test
    def test_single
      skip('캐시가 차감되서 막아놓음')
      msg = Coolsms::Message.new
      msg.text = '안녕, 세계 ㅎㅎ'
      result = msg.send(COOLSMS_TEST_RECEIVERS.first)
      assert_equal 1, result.body['success_count']
      sleep(10) # 보내는데 걸리는 시간
      sent = msg.group.first
      assert_equal '00', sent.result_code
    end

    def test_single_class_method
      skip('캐시가 차감되서 막아놓음')
      msg = Coolsms.message("안녕이라고\n말하지마", COOLSMS_TEST_RECEIVERS.first)
      sleep(10) # 보내는데 걸리는 시간
      sent = msg.group.first
      assert_equal '00', sent.result_code
    end

    def test_wrong_number
      skip('오래걸려서 스킵')
      msg = Coolsms::Message.new
      msg.text = '거기누구없소'
      result = msg.send('01911')
      assert_equal 1, result.body['success_count']
      sleep(30) # 보내는데 걸리는 시간
      sent = msg.group.first
      assert_equal '58', sent.result_code
    end

    def test_long_single
      msg = Coolsms::Message.new
      msg.text = Forgery(:lorem_ipsum).words(50)
      result = msg.send(COOLSMS_TEST_RECEIVERS.first)
      assert_equal 1, result.body['success_count']
      sleep(10)
      sent = msg.group.first
      assert_equal '00', sent.result_code
      assert_equal 'LMS', sent.type
    end
  end
end
