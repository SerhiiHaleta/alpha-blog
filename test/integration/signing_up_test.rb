require "test_helper"

class SigningUpTest < ActionDispatch::IntegrationTest
  test "get new user form and sign up" do
    get "/signup"
    assert_response :success
    assert_difference "User.count", 1 do
      post users_path, params: { user: { username: "User1", email: "testmail@mail.com", password: "password123!" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Listing all articles", response.body
  end

  test "get new user form and didn't sign up" do
    get "/signup"
    assert_response :success
    assert_no_difference "Category.count" do
      post users_path, params: { user: { username: " ", email: " ", password: " " } }
    end
    assert_response :success
    assert_match "The following errors prevented the user from being saved", response.body
  end
end
