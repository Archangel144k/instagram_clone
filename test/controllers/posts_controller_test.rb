require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get posts_index_url
    assert_response :success
  end

  test "should get show" do
    get posts_show_url
    assert_response :success
  end

  test "should get new" do
    get posts_new_url
    assert_response :success
  end

  test "should get create" do
    get posts_create_url
    assert_response :success
  end

  test "should get edit" do
    get posts_edit_url
    assert_response :success
  end

  test "should get update" do
    get posts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get posts_destroy_url
    assert_response :success
  end

  test "should get like" do
    get posts_like_url
    assert_response :success
  end

  test "should get unlike" do
    get posts_unlike_url
    assert_response :success
  end

  test "should get save" do
    get posts_save_url
    assert_response :success
  end

  test "should get unsave" do
    get posts_unsave_url
    assert_response :success
  end

  test "should get share" do
    get posts_share_url
    assert_response :success
  end

  test "should get explore" do
    get posts_explore_url
    assert_response :success
  end

  test "should get saved" do
    get posts_saved_url
    assert_response :success
  end
end
