require 'test_helper'

class XpathsControllerTest < ActionController::TestCase
  setup do
    @xpath = xpaths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:xpaths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create xpath" do
    assert_difference('Xpath.count') do
      post :create, :xpath => @xpath.attributes
    end

    assert_redirected_to xpath_path(assigns(:xpath))
  end

  test "should show xpath" do
    get :show, :id => @xpath.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @xpath.to_param
    assert_response :success
  end

  test "should update xpath" do
    put :update, :id => @xpath.to_param, :xpath => @xpath.attributes
    assert_redirected_to xpath_path(assigns(:xpath))
  end

  test "should destroy xpath" do
    assert_difference('Xpath.count', -1) do
      delete :destroy, :id => @xpath.to_param
    end

    assert_redirected_to xpaths_path
  end
end
