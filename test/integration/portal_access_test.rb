require "test_helper"

class PortalAccessTest < ActionDispatch::IntegrationTest
  include Plutonium::Testing::AuthHelpers
  include AccountsTestHelper

  setup do
    @developer = create_developer!
    @user = @developer.user
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
    login_user(@user)

    assert_equal "/dashboard", path.chomp("/")
    assert_response :success
    assert_select "h1", /#{@developer.name}/
  end

  test "users can see and edit only their own listing" do
    create_developer!(name: "Someone Else")
    login_user(@user)

    get "/dashboard/developer"
    assert_response :success
    assert_includes response.body, @developer.handle

    get "/dashboard/developer/edit"
    assert_response :success
  end

  test "users can open companies they belong to" do
    login_user(@user)

    get "/company/#{@company.to_param}"
    assert_response :success
  end

  test "users cannot open companies they do not belong to" do
    login_user(@user)

    get "/company/#{@other_company.to_param}"
    assert_includes [403, 404], response.status
  end

  test "users cannot reach the admin portal" do
    login_user(@user)

    get "/admin"
    assert_redirected_to "/admins/login"
  end
end
