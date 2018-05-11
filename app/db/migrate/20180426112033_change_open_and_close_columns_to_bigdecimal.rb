ROM::SQL.migration do
  up do
    # set_column_type(:kline1m, :open_time, 'int8 USING CAST(open_time AS int8)')
    # set_column_type(:kline1m, :close_time, 'int8 USING CAST(close_time AS int8)')
    # set_column_type(:kline5m, :open_time, 'int8 USING CAST(open_time AS int8)')
    # set_column_type(:kline5m, :close_time, 'int8 USING CAST(close_time AS int8)')
  end

  down do
    # set_column_type(:kline1m, :open_time, 'numeric USING CAST(open_time AS numeric')
    # set_column_type(:kline1m, :close_time, 'numeric USING CAST(close_time AS numeric')
    # set_column_type(:kline5m, :open_time, 'numeric USING CAST(open_time AS numeric')
    # set_column_type(:kline5m, :close_time, 'numeric USING CAST(close_time AS numeric')
  end
end
