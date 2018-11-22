class Order < ApplicationRecord
	belongs_to :grua

	def self.repuestos(dicc)
		correcto = true
		lista_a_devolver = []
		lista_errores = []
		lista_atributos = dicc["repuestos"]
		lista_atributos.each do |diccionario|
			lista = []
			a = diccionario["repuesto"]["codigo"]
			if a != ''
				if self.chequear_codigo(a.to_i)
					lista.append(a)
					lista.append(diccionario["repuesto"]["cantidad"])
					lista_a_devolver.append(lista)
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

	def self.chequear_codigo(numero)
		return Repuesto.exists?(numero)
	end

	def self.trabajos(lista_trabajos)
		lista_a_devolver = []
		lista_trabajos.each do |trabajo|
			if trabajo != ""
				lista_a_devolver.append(trabajo)
			end
		end
		return lista_a_devolver
	end
end
