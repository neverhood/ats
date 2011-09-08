require 'test_helper'

class ParsersControllerTest < ActionController::TestCase
  setup do
    @parser = parsers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parsers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parser" do
    assert_difference('Parser.count') do
      post :create, :parser => @parser.attributes
    end

    assert_redirected_to parser_path(assigns(:parser))
  end

  test "should show parser" do
    get :show, :id => @parser.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @parser.to_param
    assert_response :success
  end

  test "should update parser" do
    put :update, :id => @parser.to_param, :parser => @parser.attributes
    assert_redirected_to parser_path(assigns(:parser))
  end

  test "should destroy parser" do
    assert_difference('Parser.count', -1) do
      delete :destroy, :id => @parser.to_param
    end

    assert_redirected_to parsers_path
  end
end
