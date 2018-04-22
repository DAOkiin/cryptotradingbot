# require_relative '../../types'

# Dry::System.register_component(:exception_notifier, provider: :errbit) do
#   settings do
#     key :host, Types::Strict::String.constrained(min_size: 10)
#     key :project_id, Types::Strict::Int.constrained(gt: 0) # required, but any positive integer works
#     key :project_key, Types::Strict::String.constrained(min_size: 10)
#   end

#   init do
#     require 'airbrake-ruby'
#   end

#   start do
#     Airbrake.configure do |c|
#       c.host = config.host
#       c.project_id = config.project_id
#       c.project_key = config.project_key
#     end

#     register(:exception_notifier, Airbrake)
#   end
# end
