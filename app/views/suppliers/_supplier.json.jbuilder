json.extract! supplier, :id, :nombre, :codigo, :categoria, :correo, :telefono, :direccion, :credito, :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
