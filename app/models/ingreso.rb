class Ingreso < ApplicationRecord

	validates :proveedor, :presence => true

	def self.format(dicc)
		correcto = true
		falta = false
		lista_a_devolver = []
		lista_faltante = []
		lista_errores = []
		lista_atributos = dicc["repuestos"]
		lista_atributos.each do |diccionario|
			lista = []
			faltante = []
			a = diccionario["repuesto"]["codigo"]
			if a != ''
				if self.chequear_codigo(a.to_i)
					lista.append(a)
					lista.append(diccionario["repuesto"]["cantidad"])
					lista.append(diccionario["repuesto"]["precio"])
					lista_a_devolver.append(lista)
					if diccionario["repuesto"]["faltante"] != ''
						falta = true
						faltante = [a, diccionario["repuesto"]["faltante"]]
						lista_faltante.append(faltante)
					end
				else
					correcto = false 
					lista_errores.append(a)
				end
			end
		end
		if correcto
			return correcto, lista_a_devolver, falta, lista_faltante
		else
			return correcto, lista_errores, falta, lista_faltante
		end
	end

	def self.chequear_codigo(numero)
		return Repuesto.exists?(numero)
	end

	def self.agregar_faltantes(repuestos, repuestos_faltantes)
		repuestos_faltantes.each do |faltante|
			repuestos.each do |repuesto|
				if faltante[0] == repuesto[0]
					repuesto[1] = (repuesto[1].to_f + faltante[1].to_f).to_s
				end
			end
		end
		return repuestos
	end
end
