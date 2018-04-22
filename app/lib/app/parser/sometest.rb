module App
  module Parser
    class Sometest
      def call
        1/0
      rescue ZeroDivisionError => e
        Airbrake.notify(e)
      end
    end
  end
end
