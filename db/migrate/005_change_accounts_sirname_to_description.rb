class ChangeAccountsSirnameToDescription < ActiveRecord::Migration
  def change
    rename_column :accounts, :surname, :description
  end
end
