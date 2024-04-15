class CreateTradings < ActiveRecord::Migration[7.1]
  def change
    create_table :tradings do |t|
      t.float :amount
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
