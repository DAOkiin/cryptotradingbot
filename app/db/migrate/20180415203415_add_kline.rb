ROM::SQL.migration do
  change do
    create_table :pair do
      primary_key :id

      column :title, String, null: false
      column :text, 'text', null: false
      column :created_at, DateTime,  null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP

      primary_key :id
      String :email
      String :password_digest

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
