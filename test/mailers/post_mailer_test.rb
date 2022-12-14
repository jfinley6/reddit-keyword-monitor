require "test_helper"

class PostMailerTest < ActionMailer::TestCase
  test "post_found" do
    mail = PostMailer.post_found
    assert_equal "Post found", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
