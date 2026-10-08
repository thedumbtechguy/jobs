require "test_helper"

class EmailOptOutTest < ActiveSupport::TestCase
  include AccountsTestHelper

  setup { @user = create_user! }

  test "every category is on until the user opts out" do
    assert @user.wants_email?(:network)

    @user.opt_out_of_email!(:network)
    @user.opt_out_of_email!(:network)

    assert_not @user.wants_email?(:network)
    assert @user.wants_email?(:applications)
    assert_equal 1, @user.email_opt_outs.count
  end

  test "only known categories can be turned off" do
    assert_raises(ActiveRecord::RecordInvalid) { @user.opt_out_of_email!(:marketing) }
  end

  test "update_email_opt_outs! turns off exactly the given categories" do
    @user.opt_out_of_email!(:network)

    @user.update_email_opt_outs!(%w[applications project_credits])
    assert_equal %w[applications project_credits], @user.email_opt_outs.pluck(:category).sort

    @user.update_email_opt_outs!([])
    assert_empty @user.email_opt_outs
  end

  test "unsubscribe tokens resolve to their user and category" do
    assert_equal [@user, "network"], EmailOptOut.resolve(EmailOptOut.token_for(@user, :network))
    assert_nil EmailOptOut.resolve("garbage")
    assert_nil EmailOptOut.resolve(EmailOptOut.token_for(@user, :marketing))
    assert_nil EmailOptOut.resolve(EmailOptOut.token_for(User.new(id: 0), :network))
  end
end
