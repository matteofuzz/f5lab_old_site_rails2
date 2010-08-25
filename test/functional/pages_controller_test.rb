require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase
  
  fixtures :users
  
  def test_should_not_get_index_without_user
    get :index
    assert_redirected_to :action => 'login'
    assert_equal "Please log in", flash[:notice]
  end
  
  def test_should_get_index_with_user
    get :index, {}, {:user_id => users(:matteo).id}
    assert_response :success
    assert_template "index"
  end

  def test_should_create_page_with_user
    assert_difference('Page.count') do
      post :create, {:page => { }}, {:user_id => users(:matteo).id}
    end

    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_show_page_with_user
    get :show, {:id => pages(:one).id}, {:user_id => users(:matteo).id}
    assert_response :success
  end

  def test_should_get_edit_with_user
    get :edit, {:id => pages(:one).id}, {:user_id => users(:matteo).id}
    assert_response :success
  end

  def test_should_update_page_with_user
    put :update, {:id => pages(:one).id, :page => { }}, {:user_id => users(:matteo).id}
    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_destroy_page_with_user
    assert_difference('Page.count', -1) do
      delete :destroy, {:id => pages(:one).id}, {:user_id => users(:matteo).id}
    end

    assert_redirected_to pages_path
  end
end
