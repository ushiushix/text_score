class ChangeAccountsSirnameToDescription < ActiveRecord::Migration[4.2]
  def change
    rename_column :accounts, :surname, :description
  end
end
