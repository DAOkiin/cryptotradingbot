ROM::SQL.migration do
  change do
    create_table :kline1m do
      primary_key :id

      column :symbol1, String, size: 10, null: false
      column :symbol2, String, size: 10, null: false
      column :pair, String, size: 20, null: false
      column :open_time, Integer
      column :open, BigDecimal
      column :high, BigDecimal
      column :low, BigDecimal
      column :close, BigDecimal
      column :volume, BigDecimal
      column :close_time, Integer
    end
  end
end
