Api::Container.boot :settings, from: :system do
  before :init do
    require "types"
  end

  settings do
    key :session_secret, Types::Strict::String.constrained(filled: true)
    key :database_url, Types::Strict::String.constrained(filled: true)
  end
end
