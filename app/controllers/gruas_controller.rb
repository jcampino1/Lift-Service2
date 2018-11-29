class GruasController < ApplicationController
  before_action :set_grua, only: [:show, :edit, :update, :destroy]

  # GET /gruas
  # GET /gruas.json
  def index
    #@gruas = Grua.where(["numero_serie = ?", params[:search].to_i])
    @gruas = Grua.all.order('numero_serie ASC')
    tipo = params[:tipo]
    if tipo == "Gas"
      @gruas = @gruas.where("tipo = 'Gas'").order('numero_serie ASC')
    elsif tipo == "Electricas"
      @gruas = @gruas.where("tipo = 'Eléctrica'").order('numero_serie ASC')
    elsif tipo == "Apiladores"
      @gruas = @gruas.where("tipo = 'Apilador'").order('numero_serie ASC')
    end
    @numero = params[:search]
    if @numero
      if @gruas.exists?(@numero)
        @gruas = [@gruas.find(@numero)]
      else
        @gruas = []
      end
    end
  end

  # GET /gruas/1
  # GET /gruas/1.json
  def show
    @orders = @grua.orders.order('fecha ASC')
  end

  # GET /gruas/new
  def new
    @grua = Grua.new
  end

  # GET /gruas/1/edit
  def edit
  end

  # POST /gruas
  # POST /gruas.json
  def create
    @grua = Grua.new(grua_params)

    respond_to do |format|
      if @grua.save
        format.html { redirect_to @grua, notice: 'Grua creada exitosamente.' }
        format.json { render :show, status: :created, location: @grua }
      else
        format.html { render :new }
        format.json { render json: @grua.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gruas/1
  # PATCH/PUT /gruas/1.json
  def update
    respond_to do |format|
      if @grua.update(grua_params)
        format.html { redirect_to @grua, notice: 'Grua editada exitosamente.' }
        format.json { render :show, status: :ok, location: @grua }
      else
        format.html { render :edit }
        format.json { render json: @grua.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gruas/1
  # DELETE /gruas/1.json
  def destroy
    @grua.destroy
    respond_to do |format|
      format.html { redirect_to gruas_url, notice: 'Grua eliminada exitosamente.' }
      format.json { head :no_content }
    end
  end

  def import
    Grua.import(params[:file])
    redirect_to root_url, notice: "Grua(s) importada(s)"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grua
      @grua = Grua.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grua_params
      params.require(:grua).permit(:tipo, :numero_serie, :horometro, :lugar_actual, :cliente, :contrato,
        :propietario, :asegurada, :estado, :marca, :modelo, :serie, :motor, :patente, :ano,
        :ton, :mastil, :observaciones)
    end
end
