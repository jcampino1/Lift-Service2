class Ajuste < ApplicationRecord
	validates :razon, :sentido, :equipo, presence: true
end
