# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190118134955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ajustes", force: :cascade do |t|
    t.string "razon"
    t.string "sentido"
    t.date "fecha"
    t.string "repuestos", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "equipo"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "nombre"
    t.string "contrato"
    t.integer "telefono"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gruas", primary_key: "numero_serie", id: :integer, default: nil, force: :cascade do |t|
    t.string "tipo"
    t.float "horometro"
    t.string "lugar_actual"
    t.string "cliente"
    t.string "contrato"
    t.string "propietario"
    t.boolean "asegurada"
    t.string "estado"
    t.string "mantenciones", default: [], array: true
    t.integer "secuencia"
    t.float "horas_faltantes"
    t.float "horas_teoricas"
    t.string "dicc_mantenciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "marca"
    t.string "modelo"
    t.string "serie"
    t.string "motor"
    t.string "patente"
    t.integer "ano"
    t.integer "ton"
    t.float "mastil"
    t.text "observaciones"
    t.boolean "necesita", default: false
    t.float "horometro_inicial", default: 0.0
  end

  create_table "ingresos", force: :cascade do |t|
    t.string "proveedor"
    t.string "repuestos", default: [], array: true
    t.string "repuestos_faltantes", default: [], array: true
    t.float "total", default: 0.0
    t.date "fecha"
    t.integer "numero_factura"
    t.integer "orden_compra"
    t.boolean "abierta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "grua_id"
    t.integer "numero"
    t.string "cliente"
    t.date "fecha"
    t.time "hora_entrada"
    t.time "hora_salida"
    t.float "horometro"
    t.boolean "preventiva"
    t.boolean "correctiva"
    t.boolean "dano"
    t.string "estado_maquina"
    t.text "trabajos_realizados", default: [], array: true
    t.string "repuestos_usados", default: [], array: true
    t.string "equipo"
    t.float "total", default: 0.0
    t.float "horas_hombre"
    t.float "costo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numero_gruas"
    t.float "mano_obra"
    t.float "total_repuestos"
  end

  create_table "otros", force: :cascade do |t|
    t.string "key"
    t.float "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repuestos", force: :cascade do |t|
    t.string "codigo"
    t.string "articulo"
    t.string "familia"
    t.float "panol", default: 0.0
    t.float "movil1", default: 0.0
    t.float "movil2", default: 0.0
    t.float "stock", default: 0.0
    t.float "stock_minimo", default: 0.0
    t.float "valor", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "taller", default: 0.0
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "nombre"
    t.integer "codigo"
    t.string "categoria"
    t.string "correo"
    t.integer "telefono"
    t.string "direccion"
    t.boolean "credito"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traspasos", force: :cascade do |t|
    t.string "desde"
    t.string "hacia"
    t.date "fecha"
    t.string "repuestos", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "admin", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
