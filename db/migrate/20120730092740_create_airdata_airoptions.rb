class CreateAirdataAiroptions < ActiveRecord::Migration
  def change
    create_table :airdata_airoptions do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
