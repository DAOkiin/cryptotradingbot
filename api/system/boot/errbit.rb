App::Container.finalize(:errbit) do |_container|
  use :config

  require 'airbrake-ruby'

  Airbrake.configure do |c|
    # byebug
    c.host = App::Container['config'].errbit_host
    c.project_id = 1
    c.project_key = App::Container['config'].errbit_projectkey
  end
end
