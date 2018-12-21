class TraspasosController < ApplicationController

	def new
		@traspaso = Traspaso.new
	end

	def create
		correcto, repuestos = Traspaso.format(params[:repuestos])
		if correcto
			@traspaso = Traspaso.create(traspaso_params)
			@traspaso.repuestos = repuestos

			# Se hace el traspaso
			Repuesto.traspasar(repuestos, @traspaso.desde, @traspaso.hacia)
			respond_to do |format|
		        if @traspaso.save
		          format.html { redirect_to repuestos_url, notice: 'Traspaso creado exitosamente.' }
		          format.json { render :show, status: :created, location: @traspaso }
		        else
		          format.html { render :new }
		          format.json { render json: @traspaso.errors, status: :unprocessable_entity }
		        end
		    end
		else
			@errores = repuestos
		end
	end

	def index
		@traspasos = Traspaso.all.order('fecha DESC')
	end

	def show
		@traspaso = Traspaso.find(params[:id])
	end

	private
	
	def traspaso_params
		params.require(:traspaso).permit(:desde, :hacia, :fecha)
	end
end
