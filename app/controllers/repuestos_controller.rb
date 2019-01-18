class RepuestosController < ApplicationController
  before_action :set_repuesto, only: [:show, :edit, :update, :destroy]

  # GET /repuestos
  # GET /repuestos.json
  def index
    @q = Repuesto.search(params[:q])
    @repuestos = @q.result.order('codigo ASC')

    tipo = params[:tipo]
    if tipo == "Insumo"
      @repuestos = @repuestos.where("familia = 'Insumo'")
    elsif tipo == "Lubricante"
      @repuestos = @repuestos.where("familia = 'Lubricante'")
    elsif tipo == "Neumatico"
      @repuestos = @repuestos.where("familia = 'Neumáticos'")
    elsif tipo == "Pintura"
      @repuestos = @repuestos.where("familia = 'Pintura'")
    elsif tipo == "Repuesto"
      @repuestos = @repuestos.where("familia = 'Repuesto'")
    elsif tipo == "Seguridad"
      @repuestos = @repuestos.where("familia = 'Seguridad'")
    elsif tipo == "Faltantes"
      @repuestos = @repuestos.where("stock < stock_minimo")
    end
  end

  # GET /repuestos/1
  # GET /repuestos/1.json
  def show
  end

  # GET /repuestos/new
  def new
    @repuesto = Repuesto.new
  end

  # GET /repuestos/1/edit
  def edit
  end

  # POST /repuestos
  # POST /repuestos.json
  def create
    @repuesto = Repuesto.new(repuesto_params)

    respond_to do |format|
      if @repuesto.save
        format.html { redirect_to @repuesto, notice: 'Repuesto creado exitosamente' }
        format.json { render :show, status: :created, location: @repuesto }
      else
        format.html { render :new }
        format.json { render json: @repuesto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  # DELETE /repuestos/1
  # DELETE /repuestos/1.json
  def destroy
    @repuesto.destroy
    respond_to do |format|
      format.html { redirect_to repuestos_url, notice: 'Repuesto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    Repuesto.import(params[:file])
    redirect_to repuestos_url, notice: "Repuesto(s) importado(s)"
  end


  def actualizar_atributos
    @repuesto = Repuesto.find(params[:repuesto_id])
    @nuevo_stock_minimo = params[:nuevo_stock_minimo]
    @nuevo_valor = params[:nuevo_valor]
    if @nuevo_stock_minimo != ''
      @repuesto.stock_minimo = @nuevo_stock_minimo.to_f
    end
    if @nuevo_valor != ''
      @repuesto.valor = @nuevo_valor.to_f
    end
    @repuesto.save

    redirect_to @repuesto
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repuesto
      @repuesto = Repuesto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repuesto_params
      params.require(:repuesto).permit(:codigo, :articulo, :familia, :panol, :taller, :movil1,
       :movil2, :stock, :stock_minimo, :valor)
    end
end
