require "test_helper"

class OnboardingTest < ActionDispatch::IntegrationTest
  include Plutonium::Testing::AuthHelpers
  include AccountsTestHelper

  setup do
    @user = create_user!(email: "grace.hopper@example.com")
  end

  test "users without a listing are sent to onboarding from any portal" do
    login_user(@user)
    assert_equal "/onboarding", path

    get "/dashboard"
    assert_redirected_to "/onboarding"

    company = Company.create!(name: "Acme Labs")
    company.company_users.create!(user: @user, role: :recruiter)
    get "/company/#{company.to_param}"
    assert_redirected_to "/onboarding"
  end

  test "suggests a handle from the email" do
    login_user(@user)
    assert_select "input[name='onboarding[handle]'][value='grace-hopper']"
  end

  test "creates a personal listing" do
    login_user(@user)

    assert_difference -> { Developer.count }, 1 do
      assert_no_difference -> { Company.count } do
        post "/onboarding", params: {onboarding: {name: "Grace Hopper", handle: "grace", city: "Arlington", hiring: "0", company_name: "Ignored"}}
      end
    end

    assert_redirected_to "/dashboard/"
    assert_equal "grace", @user.reload.developer.handle
  end

  test "creates a personal listing and a company for users who are hiring" do
    login_user(@user)

    post "/onboarding", params: {onboarding: {name: "Grace Hopper", handle: "grace", hiring: "1", company_name: "Acme Labs", company_website: "https://acme.test"}}

    company = Company.find_by!(name: "Acme Labs")
    assert_redirected_to "/company/#{company.to_param}"
    assert @user.reload.developer.present?
    assert_equal "owner", company.company_users.find_by!(user: @user).role
  end

  test "creates nothing when either record is invalid" do
    create_developer!(handle: "grace")
    login_user(@user)

    assert_no_difference ["Developer.count", "Company.count"] do
      post "/onboarding", params: {onboarding: {name: "Grace Hopper", handle: "grace", hiring: "1", company_name: ""}}
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "Handle has already been taken"
    assert_includes response.body, "Company name can&#39;t be blank"
  end

  test "onboarded users are sent back to the dashboard" do
    create_developer!(user: @user)
    login_user(@user)

    get "/onboarding"
    assert_redirected_to "/dashboard/"
  end

  test "onboarded users can set up a company later" do
    create_developer!(user: @user)
    login_user(@user)

    get "/setup/company/new"
    assert_response :success

    post "/setup/company", params: {company: {name: "Later Co", website: "https://later.test"}}
    company = Company.find_by!(name: "Later Co")
    assert_redirected_to "/company/#{company.to_param}"
    assert company.company_users.exists?(user: @user, role: :owner)
  end

  test "guests cannot onboard" do
    get "/onboarding"
    assert_redirected_to "/users/login"
  end
end
