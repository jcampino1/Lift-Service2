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

ActiveRecord::Schema.define(version: 20181113152125) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clientes", force: :cascade do |t|
    t.string "nombre"
    t.string "contrato"
    t.integer "telefono"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gruas", force: :cascade do |t|
    t.string "tipo"
    t.float "numero_serie"
    t.float "horometro"
    t.string "lugar_actual"
    t.string "cliente"
    t.string "contrato"
    t.string "propietario"
    t.boolean "asegurada"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingresos", force: :cascade do |t|
    t.string "proveedor"
    t.string "repuestos", default: [], array: true
    t.float "total"
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
    t.string "estado_maquina"
    t.text "trabajos_realizados"
    t.string "repuestos_usados", default: [], array: true
    t.string "equipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repuestos", force: :cascade do |t|
    t.integer "codigo"
    t.string "articulo"
    t.float "panol"
    t.float "movil1"
    t.float "movil2"
    t.float "stock"
    t.float "stock_minimo"
    t.float "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

end
