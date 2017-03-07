require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username: "Finny23", email: "xyz828@piggs.com", password: "password", admin: false)
  end
  
  test "get new article form and create article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {title: "Plexiglass", description: "I want a tuna sandwich. Thank you.", user_id: @user}
    end
    assert_template 'articles/show'
    assert_match "Plexiglass", response.body
  end
  
  test "invalid article submission results in failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, article: {title: " ", description: "I want a baked sandwich from Quiznos.", user_id: @user}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end