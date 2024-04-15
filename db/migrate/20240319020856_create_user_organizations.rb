class CreateUserOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :user_organizations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :invitation

      t.timestamps
    end
  end
end
