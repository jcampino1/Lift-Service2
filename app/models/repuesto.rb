class Repuesto < ApplicationRecord
	validates :codigo, uniqueness: true
	require 'csv'

   	def self.import(file)
   		CSV.foreach(file.path, headers: false) do |row|
   			if row[4]
   				pan = row[4]
   			else pan = 0
   			end

   			if row[5]
   				mov1 = row[5]
   			else mov1 = 0
   			end

   			if row[6]
   				mov2 = row[6]
   			else mov2 = 0
   			end

   			if row[7]
   				sto = row[7]
   			else sto = 0
   			end

   			if row[8]
   				sto_min = row[8]
   			else sto_min = 0
   			end

   			if row[9]
   				val = row[9]
   			else val = 0
   			end

      		Repuesto.create!(codigo: row[0], articulo: row[1], familia: row[3],
      		panol: pan, movil1: mov1, movil2: mov2, stock: sto,
      		stock_minimo: sto_min, valor: val)
    	end
   	end

	def self.agregar(lista_repuestos)
		total = 0
		lista_repuestos.each do |tupla|
			r = Repuesto.find_by(codigo: tupla[0])
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
			r = Repuesto.find_by(codigo: tupla[0])
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
			r = Repuesto.find_by(codigo: tupla[0])
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

	def self.traspasar(lista_repuestos, desde, hacia)
		self.bajar(lista_repuestos, desde)
		self.subir(lista_repuestos, hacia)
	end

	def self.bajar(lista_repuestos, equipo)
		lista_repuestos.each do |tupla|
			r = Repuesto.find_by(codigo: tupla[0])
			if equipo == "Móvil 1"
				r.movil1 -= tupla[1].to_f
			elsif equipo == "Móvil 2"
				r.movil2 -= tupla[1].to_f
			else
				r.panol -= tupla[1].to_f
			end
			r.save
		end
	end

	def self.subir(lista_repuestos, equipo)
		lista_repuestos.each do |tupla|
			r = Repuesto.find_by(codigo: tupla[0])
			if equipo == "Móvil 1"
				r.movil1 += tupla[1].to_f
			elsif equipo == "Móvil 2"
				r.movil2 += tupla[1].to_f
			else
				r.panol += tupla[1].to_f
			end
			r.save
		end
	end

	def self.ajustar(lista_repuestos, sentido)
		if sentido == 'Baja'
			self.rebajar(lista_repuestos, 'Panol')
		else
			self.aumentar(lista_repuestos)
		end
	end

	def self.aumentar(lista_repuestos)
		lista_repuestos.each do |tupla|
			r = Repuesto.find_by(codigo: tupla[0])
			r.stock += tupla[1].to_f
			r.panol += tupla[1].to_f
			r.save
		end
	end

end
