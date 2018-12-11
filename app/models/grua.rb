class Grua < ApplicationRecord
	serialize :dicc_mantenciones
	serialize :dicc_a_realizar
	has_many :orders

	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, headers: false) do |row|
			if row[16] == 'Si'
				asegurada = true
			else
				asegurada = false
			end

   		grua = Grua.create!(numero_serie: row[0].to_i, tipo: row[1], horometro: row[8].to_f,
   		lugar_actual: row[11], cliente: row[12], contrato: row[13], propietario: row[15], asegurada: asegurada, 
   		estado: row[17], marca: row[2], modelo: row[3], serie: row[4], motor: row[5], patente: row[6], ano: row[7].to_i, 
   		ton: row[9].to_i, mastil: row[10].to_f, observaciones: row[14])
   		grua.dicc_mantenciones = grua.set_dicc_mantenciones(grua.tipo, grua.horometro)
   		if grua.tipo == "Eléctrica"
   			grua.mantenciones = [6000, 2000, 1000, 250]
   		elsif grua.tipo == "Gas"
   			grua.mantenciones = [2450, 1400, 700, 350]
   		elsif grua.tipo == "Apilador"
   			grua.mantenciones = [2000, 1000, 500]
   		else grua.mantenciones = []
   		end

   		grua.save
      end
 	end

 	def set_dicc_mantenciones(tipo, horometro)
 		dicc_default_gas = {350 => 0, 700 => 0, 1400 => 0, 2450 => 0}
 		dicc_default_electrica = {250 => 0, 1000 => 0, 2000 => 0, 6000 => 0}

 		# Evaluar hacerlo cada 50 hr
 		dicc_default_apilador = {500 => 0, 1000 => 0, 2000 => 0}

 		if tipo == 'Gas'
 			if horometro == 0
 				dicc = dicc_default_gas
 			else 
 				dicc = establecer_dicc(horometro, dicc_default_gas.keys)
 			end
 		elsif tipo == 'Eléctrica'
 			if horometro == 0
 				dicc = dicc_default_electrica
 			else 
 				dicc = establecer_dicc(horometro, dicc_default_electrica.keys)
 			end
 		elsif tipo == 'Apilador'
 			if horometro == 0
				dicc = dicc_default_apilador
			else
				dicc = establecer_dicc(horometro, dicc_default_apilador.keys)
			end
 		else dicc = {}
 		end
 		return dicc				
 	end

 	def establecer_dicc(horometro, lista_keys)
 		dicc = {}
 		lista_keys.each do |key|
 			dicc[key] = ((horometro - horometro%key)/key).to_i
 		end
 		return dicc 
 	end

 	def evaluar_mantenciones(horometro, dicc_mantenciones, lista_mantenciones)
 		"""
 		Devuelve siesque la grua necesita alguna mantencion y un diccionario con el valor
 		de la secuencia que se necesita mas una lista que contiene [cuanto le falta, 
 			horas teoricas a las que se le debe hacer]
 		"""
 		necesita_mantencion = false
 		dicc_a_realizar = {}

 		#dicc_mantenciones.each do |secuencia, valor|
 		lista_mantenciones.each do |secuencia|
 			valor = dicc_mantenciones[secuencia.to_i]
 			horas_para_mantencion = secuencia.to_i - (horometro - secuencia.to_i*valor)
 			if horas_para_mantencion < 100
 				necesita_mantencion = true
 				dicc_a_realizar[secuencia] = [horas_para_mantencion, (horometro + horas_para_mantencion)]
 				return true, dicc_a_realizar
 			end
 		end
 		return necesita_mantencion, dicc_a_realizar
 	end
end
