App::Container.finalize(:errbit) do |container|
  use :config

  require 'airbrake-ruby'

  Airbrake.configure do |c|
    c.host = container['config'].errbit_host
    c.project_id = 1
    c.project_key = container['config'].errbit_projectkey
  end
end
