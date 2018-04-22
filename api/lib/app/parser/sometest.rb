module App
  module Parser
    class Sometest
      def call
        1/0
      rescue ZeroDivisionError => e
        App::Container['exception_notifier'].notify(e)
      end
    end
  end
end
