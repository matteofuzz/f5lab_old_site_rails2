require File.dirname(__FILE__) + '/../test_helper'

class SlidesControllerTest < ActionController::TestCase
  
  fixtures :users
  
  def test_should_not_get_index_without_user
    get :index
    assert_redirected_to :action => 'login'
    assert_equal "Please log in", flash[:notice]
  end
  
  def test_should_get_index_with_user
    get :index, {}, {:user_id => users(:matteo).id}
    assert_response :success
    assert_not_nil assigns(:slides)
  end

  def test_should_get_new_with_user
    get :new, {}, {:user_id => users(:matteo).id}
    assert_response :success
  end

  def test_should_create_slide_with_user
    assert_difference('Slide.count') do
      post :create, {:slide => {:title => 'New', :text => 'new text'}}, {:user_id => users(:matteo).id}
    end

    assert_redirected_to slide_path(assigns(:slide))
  end

  def test_should_show_slide_with_user
    get :show, {:id => slides(:one).id}, {:user_id => users(:matteo).id}
    assert_response :success
  end

  def test_should_get_edit_with_user
    get :edit, {:id => slides(:one).id}, {:user_id => users(:matteo).id}
    assert_response :success
  end

  def test_should_update_slide_with_user
    put :update, {:id => slides(:one).id, :slide => { }}, {:user_id => users(:matteo).id}
    assert_redirected_to slide_path(assigns(:slide))
  end

  def test_should_destroy_slide_with_user
    assert_difference('Slide.count', -1) do
      delete :destroy, {:id => slides(:one).id}, {:user_id => users(:matteo).id}
    end

    assert_redirected_to slides_path
  end
end
