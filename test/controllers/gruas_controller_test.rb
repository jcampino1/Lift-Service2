require 'test_helper'

class GruasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grua = gruas(:one)
  end

  test "should get index" do
    get gruas_url
    assert_response :success
  end

  test "should get new" do
    get new_grua_url
    assert_response :success
  end

  test "should create grua" do
    assert_difference('Grua.count') do
      post gruas_url, params: { grua: {  } }
    end

    assert_redirected_to grua_url(Grua.last)
  end

  test "should show grua" do
    get grua_url(@grua)
    assert_response :success
  end

  test "should get edit" do
    get edit_grua_url(@grua)
    assert_response :success
  end

  test "should update grua" do
    patch grua_url(@grua), params: { grua: {  } }
    assert_redirected_to grua_url(@grua)
  end

  test "should destroy grua" do
    assert_difference('Grua.count', -1) do
      delete grua_url(@grua)
    end

    assert_redirected_to gruas_url
  end
end
