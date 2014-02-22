class CreateRateExchanges < ActiveRecord::Migration
  def change
    create_table :rate_exchanges do |t|

      t.timestamps
    end
  end
end
