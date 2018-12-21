class AjustesController < ApplicationController

	def new
		@ajuste = Ajuste.new
	end

	def create
		correcto, repuestos = Traspaso.format(params[:repuestos])
		if correcto
			@ajuste = Ajuste.create(ajuste_params)
			@ajuste.repuestos = repuestos

			# Se hace el traspaso
			Repuesto.ajustar(repuestos, @ajuste.sentido, @ajuste.equipo)

			respond_to do |format|
		        if @ajuste.save
		          format.html { redirect_to repuestos_url, notice: 'Ajuste creado exitosamente.' }
		          format.json { render :show, status: :created, location: @ajuste }
		        else
		          format.html { render :new }
		          format.json { render json: @ajuste.errors, status: :unprocessable_entity }
		        end
		    end

		else
			@errores = repuestos
		end
	end

	def index
		@ajustes = Ajuste.all.order('fecha DESC')
	end

	def show
		@ajuste = Ajuste.find(params[:id])
	end

	private
	
	def ajuste_params
		params.require(:ajuste).permit(:razon, :sentido, :fecha, :equipo)
	end
end
