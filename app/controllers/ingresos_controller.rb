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
    lista_repuestos = Ingreso.format(params[:repuestos])
    #lista_repuestos = params[:repuestos]["repuestos"]
    @ingreso = Ingreso.new(ingreso_params)
    #@ingreso.repuestos = lista_repuestos
    @ingreso.repuestos = lista_repuestos

    respond_to do |format|
      if @ingreso.save
        format.html { redirect_to @ingreso, notice: 'Ingreso was successfully created.' }
        format.json { render :show, status: :created, location: @ingreso }
      else
        format.html { render :new }
        format.json { render json: @ingreso.errors, status: :unprocessable_entity }
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingreso
      @ingreso = Ingreso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def ingreso_params
    #  params.require(:ingreso).permit(:proveedor, :total, {
    #    repuestos: [
    #      repuesto: [
    #        :codigo,
    #        :cantidad,
    #        :precio
    #      ]
    #    ]
    #  })
    #end

    def ingreso_params
      params.require(:ingreso).permit(:proveedor, :total)
    end
end
