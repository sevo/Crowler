class AddAttributesToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :manufacturer, :string
    add_column :products, :short_description, :text
    add_column :products, :part_number, :text
    add_column :products, :ean, :text
  end

  def self.down
    remove_column :products, :manufacturer
  end
end
