require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest
  def setup
    @user_login = User.new({ username: "User3", email: "testmail3@mail.com", password: "password" })
    @user_login.save
  end

  test "get new article form and create article" do
    sign_in_as(@user_login)
    get "/articles/new"
    assert_response :success
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "Test title", description: "Test description", category_ids: [] } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Test title", response.body
  end
end
