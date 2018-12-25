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
    @orders = @grua.orders.order('fecha DESC')
    @lista_clientes = []
    Cliente.all.each do |cliente|
      @lista_clientes.push(cliente.nombre)
    end
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
    @grua.dicc_mantenciones = @grua.set_dicc_mantenciones(@grua.tipo, @grua.horometro)

    if @grua.tipo == "Eléctrica"
        @grua.mantenciones = [6000, 2000, 1000, 250]
      elsif @grua.tipo == "Gas"
        @grua.mantenciones = [2450, 1400, 700, 350]
      elsif @grua.tipo == "Apilador"
        @grua.mantenciones = [2000, 1000, 500]
      else @grua.mantenciones = []
      end

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

  def actualizar_horometro
    @grua = Grua.find(params[:grua_id])
    @horometro_antiguo = @grua.horometro
    @hor = params[:nuevo_horometro].to_f
    @grua.horometro = @hor

    if @hor > @horometro_antiguo
      @necesita, @dicc = @grua.evaluar_mantenciones(@hor, @grua.dicc_mantenciones, 
        @grua.mantenciones)
      @grua.necesita = @necesita
      if @grua.necesita
        @grua.secuencia = @dicc.keys()[0]
        @grua.horas_faltantes = @dicc.values()[0][0]
        @grua.horas_teoricas = @dicc.values()[0][1]
      end
    end
    @grua.save

  end

  def actualizar_cliente
    @grua = Grua.find(params[:grua_id])
    if params[:cliente] != ''
      @grua.cliente = params[:cliente]
    end
    if params[:lugar] != ''
      @grua.lugar_actual = params[:lugar]
    end
    @grua.save
    redirect_to @grua
  end

  def calcular_repuestos
    @grua = Grua.find(params[:grua_id])
    @fecha_inicial = Date.new(params[:fecha_inicial].values[0].to_i,
                         params[:fecha_inicial].values[1].to_i,
                         params[:fecha_inicial].values[2].to_i)
    @fecha_final = Date.new(params[:fecha_final].values[0].to_i,
                         params[:fecha_final].values[1].to_i,
                         params[:fecha_final].values[2].to_i)
    @repuestos, @total_por_repuestos, @ordenes = @grua.calcular_repuestos(@fecha_inicial, @fecha_final)
    
    if @ordenes.length >= 2
      @hor_inicial = @ordenes[0].horometro
      @hor_final = @ordenes[-1].horometro
      @delta_hor = @hor_final - @hor_inicial
    end
  end

  def revisar_mantenciones
    @gruas = Grua.where(necesita: true).order(horas_faltantes: :asc)

    respond_to do |format|
    format.html
    format.csv { send_data @gruas.to_csv }
    format.xls { send_data @gruas.to_csv(col_sep: "\t") }
  end
  end

  def mantencion_realizada
    @grua = Grua.find(params[:grua_id])
    secuencia = params[:secuencia].to_i
    #@grua.dicc_mantenciones[secuencia] += 1
    @grua.dicc_mantenciones.keys.each do |key|
      if key <= secuencia
        @grua.dicc_mantenciones[key] += 1
      end
    end
    necesita, dicc = @grua.evaluar_mantenciones(@grua.horometro, @grua.dicc_mantenciones, @grua.mantenciones)
    @grua.necesita = necesita
    #@grua.dicc_a_realizar = dicc
    if @grua.necesita
      @grua.secuencia = dicc.keys()[0]
      @grua.horas_faltantes = dicc.values()[0][0]
      @grua.horas_teoricas = dicc.values()[0][1]
    end
    @grua.save

    redirect_back(fallback_location: root_path)
  end

  def analisis
    @gruas = Grua.all.order('numero_serie ASC')
    @fecha_inicial = Date.new(params[:fecha_inicial].values[0].to_i,
                         params[:fecha_inicial].values[1].to_i,
                         params[:fecha_inicial].values[2].to_i)
    @fecha_final = Date.new(params[:fecha_final].values[0].to_i,
                         params[:fecha_final].values[1].to_i,
                         params[:fecha_final].values[2].to_i)
    @repuestos, @total = Grua.calcular_repuestos_totales
  end

  def actualizar_hora_hombre
    nuevo_valor = params[:nuevo_valor]
    hh = Otro.find(1)
    hh.valor = nuevo_valor
    hh.save
    redirect_to root_url
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
        :ton, :mastil, :observaciones, :dicc_mantenciones)
    end
end
