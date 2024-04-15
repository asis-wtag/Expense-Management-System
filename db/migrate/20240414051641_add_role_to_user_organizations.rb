class AddRoleToUserOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_column :user_organizations, :role, :string
  end
end
