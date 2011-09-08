require 'test_helper'

class AvailableFieldsControllerTest < ActionController::TestCase
  setup do
    @available_field = available_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:available_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create available_field" do
    assert_difference('AvailableField.count') do
      post :create, :available_field => @available_field.attributes
    end

    assert_redirected_to available_field_path(assigns(:available_field))
  end

  test "should show available_field" do
    get :show, :id => @available_field.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @available_field.to_param
    assert_response :success
  end

  test "should update available_field" do
    put :update, :id => @available_field.to_param, :available_field => @available_field.attributes
    assert_redirected_to available_field_path(assigns(:available_field))
  end

  test "should destroy available_field" do
    assert_difference('AvailableField.count', -1) do
      delete :destroy, :id => @available_field.to_param
    end

    assert_redirected_to available_fields_path
  end
end
