class IngresosController < ApplicationController
  before_action :set_ingreso, only: [:show, :edit, :update, :destroy]

  # GET /ingresos
  # GET /ingresos.json
  def index
    @ingresos = Ingreso.all
  end

  # GET /ingresos/1
  # GET /ingresos/1.json
  def show
  end

  # GET /ingresos/new
  def new
    @ingreso = Ingreso.new
  end

  # GET /ingresos/1/edit
  def edit
  end

  # POST /ingresos
  # POST /ingresos.json
  def create
    # Se ve siesque estan correctos los input
    correcto, lista_repuestos, falta, lista_faltante = Ingreso.format(params[:repuestos])
    
    if correcto
      @ingreso = Ingreso.new(ingreso_params)
      @ingreso.repuestos = lista_repuestos


      # Aca se agregan al inventario y se calcula el total agregado
      @ingreso.total = Repuesto.agregar(lista_repuestos)
      
      # Si es que hay faltante
      if falta
        @ingreso.abierta = true # Se deja abierta la OC
        @ingreso.repuestos_faltantes = lista_faltante
      end

      respond_to do |format|
        if @ingreso.save
          format.html { redirect_to @ingreso, notice: 'Ingreso was successfully created.' }
          format.json { render :show, status: :created, location: @ingreso }
        else
          format.html { render :new }
          format.json { render json: @ingreso.errors, status: :unprocessable_entity }
        end
      end
    else
      @errores = lista_repuestos
    end
  end


  # PATCH/PUT /ingresos/1
  # PATCH/PUT /ingresos/1.json
  def update
    respond_to do |format|
      if @ingreso.update(ingreso_params)
        format.html { redirect_to @ingreso, notice: 'Ingreso was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingreso }
      else
        format.html { render :edit }
        format.json { render json: @ingreso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingresos/1
  # DELETE /ingresos/1.json
  def destroy
    @ingreso.destroy
    respond_to do |format|
      format.html { redirect_to ingresos_url, notice: 'Ingreso was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def completar
    @ingreso = Ingreso.find(params[:ingreso_id])
    total_agregado = Repuesto.agregar_faltantes(@ingreso.repuestos_faltantes)
    @ingreso.repuestos = Ingreso.agregar_faltantes(@ingreso.repuestos, @ingreso.repuestos_faltantes)
    @ingreso.total += total_agregado
    @ingreso.abierta = false
    @ingreso.repuestos_faltantes = []
    @ingreso.save
    redirect_to @ingreso
  end

  def cerrar
    @ingreso = Ingreso.find(params[:ingreso_id])
    @ingreso.abierta = false
    @ingreso.repuestos_faltantes = []
    @ingreso.save
    redirect_to @ingreso
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingreso
      @ingreso = Ingreso.find(params[:id])
    end

    def ingreso_params
      params.require(:ingreso).permit(:proveedor, :total, :fecha, :numero_factura,
       :orden_compra)
    end
end
