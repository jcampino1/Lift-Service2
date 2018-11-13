class GruasController < ApplicationController
  before_action :set_grua, only: [:show, :edit, :update, :destroy]

  # GET /gruas
  # GET /gruas.json
  def index
    @gruas = Grua.all
  end

  # GET /gruas/1
  # GET /gruas/1.json
  def show
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grua
      @grua = Grua.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grua_params
      params.require(:grua).permit(:tipo, :numero_serie, :horometro, :lugar_actual, :cliente, :contrato,
        :propietario, :asegurada, :estado)
    end
end
