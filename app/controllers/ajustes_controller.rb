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
			Repuesto.ajustar(repuestos, @ajuste.sentido)
			@ajuste.save

			redirect_to repuestos_url
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
		params.require(:ajuste).permit(:razon, :sentido, :fecha)
	end
end
