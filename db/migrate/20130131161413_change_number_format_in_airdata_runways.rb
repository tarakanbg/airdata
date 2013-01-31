class ChangeNumberFormatInAirdataRunways < ActiveRecord::Migration
  def up
    change_column :airdata_runways, :number, :string
  end

  def down
    change_column :airdata_runways, :number, :integer
  end
end
