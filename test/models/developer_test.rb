require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  include AccountsTestHelper

  test "normalizes the handle" do
    assert_equal "ada", Developer.new(handle: " @Ada ").handle
  end

  test "rejects badly formed and reserved handles" do
    developer = Developer.new(name: "Ada", user: create_user!)

    ["a", "has space", "-leading", "admin", "dashboard"].each do |handle|
      developer.handle = handle
      assert_not developer.valid?, "expected #{handle.inspect} to be invalid"
      assert developer.errors[:handle].any?
    end
  end

  test "allows one listing per user" do
    developer = create_developer!
    duplicate = Developer.new(user: developer.user, name: "Again", handle: "again")

    assert_not duplicate.valid?
    assert duplicate.errors[:user].any?
  end

  test "uses the handle in URLs" do
    assert_equal "ada", Developer.new(handle: "ada").to_param
  end
end
