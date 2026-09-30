class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :website, null: false
      t.text :description, null: false
      t.string :city, null: false
      t.string :country, null: false

      t.timestamps
    end
    add_index :companies, :name, unique: true
  end
end
