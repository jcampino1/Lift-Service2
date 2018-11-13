require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post orders_url, params: { order: { cliente: @order.cliente, equipo: @order.equipo, estado_maquina: @order.estado_maquina, fecha: @order.fecha, grua_id: @order.grua_id, hora_entrada: @order.hora_entrada, hora_salida: @order.hora_salida, horometro: @order.horometro, numero: @order.numero, preventiva: @order.preventiva, repuestos_usados: @order.repuestos_usados, trabajos_realizados: @order.trabajos_realizados } }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { cliente: @order.cliente, equipo: @order.equipo, estado_maquina: @order.estado_maquina, fecha: @order.fecha, grua_id: @order.grua_id, hora_entrada: @order.hora_entrada, hora_salida: @order.hora_salida, horometro: @order.horometro, numero: @order.numero, preventiva: @order.preventiva, repuestos_usados: @order.repuestos_usados, trabajos_realizados: @order.trabajos_realizados } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
