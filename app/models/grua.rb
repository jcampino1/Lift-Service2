class Grua < ApplicationRecord
	has_many :orders

	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, headers: false) do |row|
			if row[16] == 'Si'
				asegurada = true
			else
				asegurada = false
			end

   		Grua.create!(numero_serie: row[0].to_i, tipo: row[1], horometro: row[8].to_f,
   		lugar_actual: row[11], cliente: row[12], contrato: row[13], propietario: row[15], asegurada: asegurada, 
   		estado: row[17], marca: row[2], modelo: row[3], serie: row[4], motor: row[5], patente: row[6], ano: row[7].to_i, 
   		ton: row[9].to_i, mastil: row[10].to_f, observaciones: row[14])
      end
 	end
end
