require 'test_helper'

class CamaCampaignMailerTest < ActionMailer::TestCase
  test "send_content" do
    mail = CamaCampaignMailer.send_content
    assert_equal "Send content", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
