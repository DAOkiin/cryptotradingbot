ROM::SQL.migration do
  change do
    alter_table(:kline1m) do
      add_column :interval, String, default: '1m'
    end

    alter_table(:kline5m) do
      add_column :interval, String, default: '5m'
    end
  end
end
