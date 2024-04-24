class AddOrganizationToComments < ActiveRecord::Migration[7.1]
  def change
    add_reference :comments, :organization, null: false, foreign_key: true
  end
end
