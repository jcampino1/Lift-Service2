require 'test_helper'

class RepuestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repuesto = repuestos(:one)
  end

  test "should get index" do
    get repuestos_url
    assert_response :success
  end

  test "should get new" do
    get new_repuesto_url
    assert_response :success
  end

  test "should create repuesto" do
    assert_difference('Repuesto.count') do
      post repuestos_url, params: { repuesto: { articulo: @repuesto.articulo, codigo: @repuesto.codigo, movil1: @repuesto.movil1, movil2: @repuesto.movil2, panol: @repuesto.panol, stock: @repuesto.stock, stock_minimo: @repuesto.stock_minimo, valor: @repuesto.valor } }
    end

    assert_redirected_to repuesto_url(Repuesto.last)
  end

  test "should show repuesto" do
    get repuesto_url(@repuesto)
    assert_response :success
  end

  test "should get edit" do
    get edit_repuesto_url(@repuesto)
    assert_response :success
  end

  test "should update repuesto" do
    patch repuesto_url(@repuesto), params: { repuesto: { articulo: @repuesto.articulo, codigo: @repuesto.codigo, movil1: @repuesto.movil1, movil2: @repuesto.movil2, panol: @repuesto.panol, stock: @repuesto.stock, stock_minimo: @repuesto.stock_minimo, valor: @repuesto.valor } }
    assert_redirected_to repuesto_url(@repuesto)
  end

  test "should destroy repuesto" do
    assert_difference('Repuesto.count', -1) do
      delete repuesto_url(@repuesto)
    end

    assert_redirected_to repuestos_url
  end
end
