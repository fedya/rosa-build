class SetStringTypeForKeyPairsKeyid < ActiveRecord::Migration
  def up
  	change_column :key_pairs, :key_id, :string
  end

  def down
  	change_column :key_pairs, :key_id, :integer
  end
end
