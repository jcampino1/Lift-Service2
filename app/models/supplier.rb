class Supplier < ApplicationRecord
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: false) do |row|
    	if row[6] == 'SI'
      		credito = true
      	else
      		credito = false
      	end	
      	Supplier.create!(codigo: row[0], nombre: row[1], categoria: row[2],
      		correo: row[3], telefono: row[4], direccion: row[5], credito: credito)
    end
  end

end
