require "test_helper"

class EmailSettingsTest < ActionDispatch::IntegrationTest
  include Plutonium::Testing::AuthHelpers
  include AccountsTestHelper

  setup { @user = create_profile!.user }

  test "needs sign-in" do
    get "/dashboard/settings/email"
    assert_response :redirect
  end

  test "shows every category, on by default" do
    login_user(@user)
    get "/dashboard/settings/email"

    assert_response :success
    assert_select "input[type=checkbox][name='email_settings[categories][]']", 3
    assert_select "input[type=checkbox][name='email_settings[categories][]'][checked]", 3
  end

  test "saving turns off unticked categories and back on ticked ones" do
    @user.opt_out_of_email!(:project_credits)
    login_user(@user)

    patch "/dashboard/settings/email", params: {email_settings: {categories: ["", "network", "project_credits"]}}

    assert_redirected_to "/dashboard/settings/email"
    assert_equal ["applications"], @user.email_opt_outs.pluck(:category)
  end

  test "the user menu links to the page" do
    login_user(@user)
    get "/dashboard"
    assert_select "a[href='/dashboard/settings/email']", /Email notifications/
  end
end
