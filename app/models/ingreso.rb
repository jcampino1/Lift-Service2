class Ingreso < ApplicationRecord

	def self.format(dicc)
		lista_a_devolver = []
		lista_atributos = dicc["repuestos"]
		lista_atributos.each do |diccionario|
			lista = []
			a = diccionario["repuesto"]["codigo"]
			if a != ''
				if self.chequear_codigo(a.to_i)
					lista.append(a)
					lista.append(diccionario["repuesto"]["cantidad"])
					lista.append(diccionario["repuesto"]["precio"])
					lista_a_devolver.append(lista)
				end
			end
		end
  		return lista_a_devolver
	end

	def self.chequear_codigo(numero)
		return Repuesto.where(codigo: numero).take
	end
end
