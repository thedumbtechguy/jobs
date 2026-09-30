require "test_helper"

class PortalAccessTest < ActionDispatch::IntegrationTest
  include Plutonium::Testing::AuthHelpers

  setup do
    @user = User.create!(email: "dev@example.com", status: :verified, password_hash: BCrypt::Password.create("password123"))
    @company = Company.create!(name: "Acme Labs")
    @company.company_users.create!(user: @user, role: :owner)
    @other_company = Company.create!(name: "Other Co")
  end

  test "guests are sent to the user login" do
    get "/dashboard"
    assert_redirected_to "/users/login"

    get "/company/#{@company.to_param}"
    assert_redirected_to "/users/login"
  end

  test "users land on the dashboard after logging in" do
    login_as(@user, portal: :user)
    follow_redirect! while response.redirect? # /welcome checks for pending invites first

    assert_equal "/dashboard", path.chomp("/")
    assert_response :success
  end

  test "users can open companies they belong to" do
    login_as(@user, portal: :user)

    get "/company/#{@company.to_param}"
    assert_response :success
  end

  test "users cannot open companies they do not belong to" do
    login_as(@user, portal: :user)

    get "/company/#{@other_company.to_param}"
    assert_includes [403, 404], response.status
  end

  test "users cannot reach the admin portal" do
    login_as(@user, portal: :user)

    get "/admin"
    assert_redirected_to "/admins/login"
  end
end
