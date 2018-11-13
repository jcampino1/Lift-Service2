require 'test_helper'

class IngresosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ingreso = ingresos(:one)
  end

  test "should get index" do
    get ingresos_url
    assert_response :success
  end

  test "should get new" do
    get new_ingreso_url
    assert_response :success
  end

  test "should create ingreso" do
    assert_difference('Ingreso.count') do
      post ingresos_url, params: { ingreso: { proveedor: @ingreso.proveedor, repuestos: @ingreso.repuestos, total: @ingreso.total } }
    end

    assert_redirected_to ingreso_url(Ingreso.last)
  end

  test "should show ingreso" do
    get ingreso_url(@ingreso)
    assert_response :success
  end

  test "should get edit" do
    get edit_ingreso_url(@ingreso)
    assert_response :success
  end

  test "should update ingreso" do
    patch ingreso_url(@ingreso), params: { ingreso: { proveedor: @ingreso.proveedor, repuestos: @ingreso.repuestos, total: @ingreso.total } }
    assert_redirected_to ingreso_url(@ingreso)
  end

  test "should destroy ingreso" do
    assert_difference('Ingreso.count', -1) do
      delete ingreso_url(@ingreso)
    end

    assert_redirected_to ingresos_url
  end
end
