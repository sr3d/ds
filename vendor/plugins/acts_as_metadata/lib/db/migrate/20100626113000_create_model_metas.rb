class CreateModelMetas < ActiveRecord::Migration
  def self.up
    create_table :model_metas do |t|
      t.column :key, :string, :null => false
      t.column :model, :string, :null => false
      t.column :model_id, :integer, :null => false
      t.column :value, :string, :null => false
    end
    add_index :model_metas, [ :model, :key, :model_id]
  end

  def self.down
    drop_table :model_metas
  end
end
