class Repuesto < ApplicationRecord
	require 'csv'

   	def self.import(file)
   		CSV.foreach(file.path, headers: false) do |row|
      		Repuesto.create!(articulo: row[1], codigo: row[0], valor: row[5])
    	end
   	end

	def self.agregar(lista_repuestos)
		lista_repuestos.each do |tupla|
			r = Repuesto.find(tupla[0].to_i)
			r.panol += tupla[1].to_f
			r.stock += tupla[1].to_f
			if tupla[2].to_f != 0
				r.valor = tupla[2].to_f
			end
			r.save
		end
	end

	def self.rebajar(lista_repuestos, equipo)
		lista_repuestos.each do |tupla|
			r = Repuesto.find(tupla[0].to_i)
			r.stock -= tupla[1].to_f
			if equipo == "Taller1"
				r.movil1 -= tupla[1].to_f
			elsif equipo == "Taller2"
				r.movil2 -= tupla[1].to_f
			else
				r.panol -= tupla[1].to_f
			end
			r.save
		end
	end
end
