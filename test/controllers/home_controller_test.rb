require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "renders the landing page" do
    get root_path
    assert_response :success
    assert_select "h1", "Dev Registry"
  end
end
