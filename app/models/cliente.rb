class Cliente < ApplicationRecord
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: false) do |row|
      	Cliente.create!(nombre: row[0], contrato: row[1], telefono: row[2])
    end
  end
end
