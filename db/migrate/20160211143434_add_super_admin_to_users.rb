class AddSuperAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :super_admin, :boolean, null: false, default: false
  end
end
