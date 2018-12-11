class Repuesto < ApplicationRecord
	require 'csv'

   	def self.import(file)
   		CSV.foreach(file.path, headers: false) do |row|
      		Repuesto.create!(articulo: row[1], codigo: row[0], valor: row[5])
    	end
   	end

	def self.agregar(lista_repuestos)
		total = 0
		lista_repuestos.each do |tupla|
			r = Repuesto.find(tupla[0].to_i)
			cantidad = tupla[1].to_f
			r.panol += cantidad
			r.stock += cantidad
			if tupla[2].to_f != 0
				r.valor = tupla[2].to_f
			end
			r.save
			total += cantidad*r.valor
		end
		return total
	end

	def self.agregar_faltantes(lista_repuestos)
		total = 0
		lista_repuestos.each do |tupla|
			r = Repuesto.find(tupla[0].to_i)
			cantidad = tupla[1].to_f
			r.panol += cantidad
			r.stock += cantidad
			r.save
			total += cantidad*r.valor
		end
		return total
	end

	def self.rebajar(lista_repuestos, equipo)
		total = 0
		lista_repuestos.each do |tupla|
			r = Repuesto.find(tupla[0].to_i)
			r.stock -= tupla[1].to_f
			if equipo == "Móvil 1"
				r.movil1 -= tupla[1].to_f
			elsif equipo == "Móvil 2"
				r.movil2 -= tupla[1].to_f
			else
				r.panol -= tupla[1].to_f
			end
			r.save
			total += tupla[1].to_f*r.valor
		end
		return total
	end
end
