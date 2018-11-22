class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_grua, only: [:show, :edit, :update, :destroy, :index, :new, :create]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = @grua.orders.build
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json

  def create
    lista_trabajos = Order.trabajos(params[:trabajos])
    correcto, lista_repuestos = Order.repuestos(params[:repuestos])
    if correcto
      @order = @grua.orders.build(order_params)
      @order.grua = @grua
      @order.trabajos_realizados = lista_trabajos
      @order.repuestos_usados = lista_repuestos
      @order.save

      Repuesto.rebajar(lista_repuestos, @order.equipo)

      redirect_to grua_orders_url
    else
      @errores = lista_repuestos
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @order = @grua.orders.find(params[:id])
    respond_to do |format|
      if @order.update(order_params)
        format.html do
          redirect_to grua_orders_url,
                      notice: 'Orden de trabajo correctamente actualizada.'
        end
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json do
          render json: @order.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json

  def destroy
    @order = @grua.orders.find(params[:id]).destroy
    redirect_to grua_orders_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_grua
      @grua = Grua.find(params[:grua_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:grua_id, :numero, :cliente, :fecha, :hora_entrada,
       :hora_salida, :horometro, :preventiva, :estado_maquina, :trabajos_realizados,
        :repuestos_usados, :equipo, :order_id)
    end
end
