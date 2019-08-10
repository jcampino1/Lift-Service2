class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_grua, only: [:show, :edit, :update, :destroy, :index, :new, :create]

  # GET /orders
  # GET /orders.json
  
  def index
    @orders = @grua.orders.order('fecha ASC')

    respond_to do |format|
      format.html
      format.csv { send_data @orders.to_csv }
      format.xls { send_data @orders.to_csv(col_sep: "\t") }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @valor_hh = @order.mano_obra/@order.horas_hombre
  end

  # GET /orders/new
  def new
    @order = @grua.orders.build
  end

  # GET /orders/1/edit
  def edit
  end


  def create

    @parametros = params["order"]
    @estan_todos = true
    if @parametros["cliente"].empty? or @parametros["numero"].empty? or @parametros["equipo"].empty? or @parametros["horometro"].empty? or @parametros["costo"].empty? or @parametros["numero_gruas"].empty?
      @estan_todos = false
    end

    if @estan_todos

      # Para ver que el horometro sea mayor
      malo = false
      horometro = order_params[:horometro].to_f
      if horometro < @grua.horometro
        @malo = true
      end

      # Para los trabajos y repuestos
      lista_trabajos = Order.trabajos(params[:trabajos])
      correcto, lista_repuestos = Order.repuestos(params[:repuestos])


      if correcto and not @malo
        @order = @grua.orders.build(order_params)
        @order.grua = @grua

        @order.costo = @order.costo/@order.numero_gruas

        @order.trabajos_realizados = lista_trabajos
        @order.repuestos_usados = lista_repuestos
        
        # Si es que no puso nada en HH
        if not @order.horas_hombre
          @order.horas_hombre = (@order.hora_salida - @order.hora_entrada)/3600
        end

        # Guardar este total
        if @order.equipo == "Central"
          total_repuestos = Repuesto.rebajar(lista_repuestos, "Taller")
        else
          total_repuestos = Repuesto.rebajar(lista_repuestos, @order.equipo)
        end
        @order.total_repuestos = total_repuestos

        # Guardar el total por mano de obra
        valor_hh = Otro.find(1).valor
        @order.mano_obra = @order.horas_hombre*valor_hh

        # Total de la OT con los precios historicos
        @order.total = @order.costo + total_repuestos + @order.mano_obra

        # Actualizar horometro y ver mantenciones
        @grua.horometro = horometro
        @necesita, @dicc = @grua.evaluar_mantenciones(horometro, @grua.dicc_mantenciones, 
          @grua.mantenciones, @grua.horometro_inicial)
        @grua.necesita = @necesita
        if @grua.necesita
          @grua.secuencia = @dicc.keys()[0]
          @grua.horas_faltantes = @dicc.values()[0][0]
          @grua.horas_teoricas = @dicc.values()[0][1]
        end
        @grua.save

        @order.save


        redirect_to grua_path(id: @grua.id)
      else
        @errores = lista_repuestos
      end
    else
      @faltantes = []
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
    Repuesto.reponer(@order.repuestos_usados, @order.equipo)
    @order = @grua.orders.find(params[:id]).destroy
    redirect_to @grua
  end

  def arreglar_valor_hh
    valor_actual = Otro.find(1).valor
    Order.all.each do |order|
      # Aqui actualizamos los valores de mano de obra para cada orden de compra
      order.mano_obra = order.horas_hombre*valor_actual
      # Total de la OT con el nuevo valor de la HH
      order.total = order.costo + order.total_repuestos + order.mano_obra
      order.save
    end
    redirect_to root_url, alert: "HH actualizada"
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
       :hora_salida, :horas_hombre, :horometro, :preventiva, :correctiva, :dano, :estado_maquina, :trabajos_realizados,
        :repuestos_usados, :equipo, :order_id, :costo, :numero_gruas)
    end
end
