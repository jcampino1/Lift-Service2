class Grua < ApplicationRecord
	serialize :dicc_mantenciones
	has_many :orders

	require 'csv'

	def self.to_csv(options = {})
		column_names = %w{numero_serie cliente horometro secuencia horas_faltantes horas_teoricas}
		CSV.generate(options) do |csv|
		    csv << ['Numero interno', 'Cliente', 'Horometro', 'Secuencia', 'Horas faltantes', 'Horas teoricas']
		    all.each do |grua|
		      csv << grua.attributes.values_at(*column_names)
		    end
  		end
	end

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
   			grua.mantenciones = [2800, 1400, 700, 350]
   		elsif grua.tipo == "Apilador"
   			grua.mantenciones = [2000, 1000, 500]
   		else grua.mantenciones = []
   		end

   		grua.save
      end
 	end

 	def self.importar_horometros_iniciales(file)
 		CSV.foreach(file.path, headers: false) do |row|
 			grua = Grua.find(row[0].to_i)
 			grua.horometro_inicial = row[1].to_f
 			grua.horometro = row[1].to_f
 			grua.dicc_mantenciones = grua.set_dicc_mantenciones(grua.tipo, grua.horometro - row[1].to_f)
 			grua.necesita, dicc = grua.evaluar_mantenciones(grua.horometro, grua.dicc_mantenciones, grua.mantenciones, grua.horometro_inicial)
		    if grua.necesita
		      grua.secuencia = dicc.keys()[0]
		      grua.horas_faltantes = dicc.values()[0][0]
		      grua.horas_teoricas = dicc.values()[0][1]
		    end
 			grua.save
 		end
 	end

 	def set_dicc_mantenciones(tipo, horometro)
 		dicc_default_gas = {350 => 0, 700 => 0, 1400 => 0, 2800 => 0}
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
 			valor = ((horometro - horometro%key)/key).to_i
 			if valor > 0
 				dicc[key] = valor
 			else
 				dicc[key] = 0
 			end
 		end
 		return dicc 
 	end

 	def evaluar_mantenciones(horometro, dicc_mantenciones, lista_mantenciones, hor_inicial)
 		"""
 		Devuelve siesque la grua necesita alguna mantencion y un diccionario con el valor
 		de la secuencia que se necesita mas una lista que contiene [cuanto le falta, 
 			horas teoricas a las que se le debe hacer]
 		"""
 		dicc_a_realizar = {}
 		# Para el caso de la grua a Gas esta lista seria = [2800, 1400, 700, 350]
 		# El caso de la 1050 podria ocurrir antes de 700
 		lista_mantenciones.each do |secuencia|

 			if secuencia.to_i == 700
 				# Vemos si es de 1050. Solo nos preocupamos de ver si es de 1050
 				# Si interfiere con una de 700 da lo mismo porque al apretar mantencion
 				# realizada esto se hara automatico
 				valor = (dicc_mantenciones[350] / 3).to_i
 				horas_para_mantencion = 1050 - ((horometro - horometro_inicial) - 1050*valor)
 				if horas_para_mantencion < 100
	 				dicc_a_realizar[1050] = [horas_para_mantencion, (horometro + horas_para_mantencion)]
	 				return true, dicc_a_realizar
	 			end
 			end

 			valor = dicc_mantenciones[secuencia.to_i]
 			horas_para_mantencion = secuencia.to_i - ((horometro - hor_inicial) - secuencia.to_i*valor)
 			
 			if horas_para_mantencion < 100
 				dicc_a_realizar[secuencia] = [horas_para_mantencion, (horometro + horas_para_mantencion)]
 				return true, dicc_a_realizar
 			end
 		end

 		return false, {}
 	end

 	def calcular_repuestos(fecha_inicial, fecha_final)
 		ordenes = self.orders.where(:fecha => fecha_inicial..fecha_final).order('fecha ASC')
 		total = 0
 		dicc_repuestos = {}
 		ordenes.each do |orden|
 			orden.repuestos_usados.each do |tupla|
 				if dicc_repuestos.keys.include?(tupla[0])
 					dicc_repuestos[tupla[0]] += tupla[1].to_f
 				else
 					dicc_repuestos[tupla[0]] = tupla[1].to_f
 				end
 			end
 			total += orden.total_repuestos
 		end
 		return dicc_repuestos, total, ordenes
 	end

 	def self.calcular_repuestos_totales(fecha_inicial, fecha_final)
 		dicc_repuestos = {}
 		total = 0
 		gruas = Grua.all
 		gruas.each do |grua|
 			dicc_grua = {}
 			ordenes = grua.orders.where(:fecha => fecha_inicial..fecha_final)
 			ordenes.each do |orden|
 				orden.repuestos_usados.each do |tupla|
					if dicc_repuestos.keys.include?(tupla[0])
 						dicc_repuestos[tupla[0]] += tupla[1].to_f
 					else
 						dicc_repuestos[tupla[0]] = tupla[1].to_f
 					end
 					total += orden.total
 				end
 			end
 		end
 		return dicc_repuestos, total
 	end


end
