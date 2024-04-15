class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, limit: 30
      t.string :email, limit: 50
      t.string :password, limit: 20

      t.timestamps
    end
  end
end
