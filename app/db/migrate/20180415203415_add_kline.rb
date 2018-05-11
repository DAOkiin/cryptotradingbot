ROM::SQL.migration do
  change do
    create_table :kline1m do
      primary_key :id

      column :symbol1, String, size: 10, null: false
      column :symbol2, String, size: 10, null: false
      column :pair, String, size: 20, null: false
      column :open_time, :Bignum, unique: true
      column :open, BigDecimal
      column :high, BigDecimal
      column :low, BigDecimal
      column :close, BigDecimal
      column :volume, BigDecimal
      column :close_time, :Bignum

      index :open_time
    end
  end
end
