class Traspaso < ApplicationRecord
	def self.format(dicc)
		correcto = true
		lista_a_devolver = []
		lista_errores = []
		lista_atributos = dicc["repuestos"]
		lista_atributos.each do |diccionario|
			lista = []
			a = diccionario["repuesto"]["codigo"]
			if a != ''
				if self.chequear_codigo(a)
					lista.append(a)
					if diccionario["repuesto"]["cantidad"] != ''
						lista.append(diccionario["repuesto"]["cantidad"])
						lista_a_devolver.append(lista)
					end
				else
					correcto = false 
					lista_errores.append(a)
				end
			end
		end
		if correcto
			return correcto, lista_a_devolver
		else
			return correcto, lista_errores
		end
	end

	def self.chequear_codigo(a)
		return Repuesto.exists?(codigo: a)
	end
end
