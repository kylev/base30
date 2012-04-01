class CreateParentsAndKids < ActiveRecord::Migration
  def self.up
    create_table :parents do |t|
      t.string :name
      t.integer :kids_count, :default => 0

      t.timestamps
    end

    create_table :kids do |t|
      t.integer :parent_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :parents
    drop_table :kids
  end
end
