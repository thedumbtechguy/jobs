require "test_helper"

class Developers::ProfileTest < ActiveSupport::TestCase
  include AccountsTestHelper

  test "normalizes the handle and uses it in URLs" do
    profile = create_profile!(handle: " @Ada ")
    assert_equal "ada", profile.handle
    assert_equal "ada", profile.to_param
  end

  test "rejects badly formed and reserved handles" do
    profile = Developers::Profile.new(name: "Ada", user: create_user!)

    ["a", "has space", "-leading", "admin", "developer"].each do |handle|
      profile.handle = handle
      assert_not profile.valid?, "expected #{handle.inspect} to be invalid"
      assert profile.errors[:handle].any?
    end
  end

  test "allows one profile per user" do
    profile = create_profile!
    duplicate = Developers::Profile.new(user: profile.user, name: "Again", handle: "again")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user], "already has a developer profile"
  end
end
