# Extra methods for mathematical calculations.
module Enumerable
  def sum
    inject(0) { |accum, i| accum + i }
  end

  def mean
    sum / length.to_f
  end

  def sample_variance
    m = mean
    sum = inject(0) { |accum, i| accum + (i - m)**2 }
    sum / (length - 1).to_f
  end

  def standard_deviation
    Math.sqrt(sample_variance)
  end
end

module Indicators
  # Main helper methods
  class Helper
    # Error handling.
    class HelperException < StandardError; end

    def self.validate_data(data, column, parameters)
      # If this is a hash, choose which column of values to use for calculations
      valid_data = data.is_a?(Hash) ? data[column] : data

      if valid_data.length < parameters
        raise HelperException, "Data point length (#{valid_data.length}) must be greater than or equal to the required indicator periods (#{parameters})."
      end
      valid_data
    end

    # Indicators::Helper.get_parameters([12, 1, 1], 0, 15)
    def self.get_parameters(parameters, i = 0, default = 0)

      # Single parameter is to choose from.
      if parameters.is_a?(Integer) || parameters.is_a?(NilClass)
        # Set all other to default if only one integer is given instead of an array.
        return default if i != 0

        # Check if no parameters are specified at all, if so => set to default.
        # Parameters 15, 0, 0 are equal to 15 or 15, nil, nil.
        if parameters.nil? || parameters.zero?
          raise HelperException, 'There were no parameters specified and there is no default for it.' unless default != 0
          return default
        else
          return parameters
        end
      # Multiple parameters to choose from.
      elsif parameters.is_a?(Array)
        # Map in case array is ["1", "2"] instead of [1, 2]. This usually happens when getting data from input forms.
        # Specify default as Float or Int, to indicate what is expected from the param.
        if default.is_a?(Integer)
          parameters = parameters.map(&:to_i)
        elsif default.is_a?(Float)
          parameters = parameters.map(&:to_f)
        end

        if parameters[i].nil? || parameters[i].zero?
          if default != 0
            return default
          else
            raise HelperException, 'There were no parameters specified and there is no default for it.'
          end
        else
          return parameters[i]
        end
      else
        raise HelperException, 'Parameters must be an integer, float, an array or nil.'
      end
    end
  end

  # Simple Moving Average
  class Sma
    # SMA: (sum of closing prices for x period)/x
    def self.calculate(data, periods)
      output = []
      # Returns an array from the requested column and checks if there is enought data points.
      adj_closes = Indicators::Helper.validate_data(data, :adj_close, periods)

      adj_closes.each_with_index do |_adj_close, index|
        start = index + 1 - periods
        if index + 1 >= periods
          adj_closes_sum = adj_closes[start..index].sum
          output[index] = (adj_closes_sum / periods.to_f)
        else
          output[index] = nil
        end
      end
      output
    end
  end

  class Data
    attr_reader :data, :results
    INDICATORS = %i[sma ema bb macd rsi sto].freeze
    # Error handling
    class DataException < StandardError; end

    def initialize(params)
      @data = params

      # Check if data usable.
      raise DataException, 'There is no data to work on.' if @data.nil? || @data.empty?
      raise DataException, "Alien data. Given data must be an array (got #{@data.class})." unless @data.is_a?(Array)
    end

    def calc(params)
      # Check is parameters are usable.
      raise DataException, 'Given parameters have to be a hash.' unless params.is_a?(Hash)

      # If not specified, set default :type to :sma.
      params[:type] = :sma if params[:type].nil? || params[:type].empty?

      # Check if there is such indicator type supported.
      raise DataException, "Invalid indicator type specified (#{params[:type]})." unless INDICATORS.include?(params[:type])

      @results = Main.new(@data, params)
    end
  end

  class Main
    attr_reader :output, :abbr, :params
    # Error handling.
    class MainException < StandardError ; end

    def initialize(data, parameters)
      type = parameters[:type]
      all_params = parameters[:params]
      @abbr = type.to_s.upcase
      case type
      when :sma
        @params = Indicators::Helper.get_parameters(all_params, 0, 20)
      when :ema
        @params = Indicators::Helper.get_parameters(all_params, 0, 20)
      when :bb
        @params = Array.new
        @params << Indicators::Helper.get_parameters(all_params, 0, 20)
        @params << Indicators::Helper.get_parameters(all_params, 1, 2.0)
      when :macd
        @params = Array.new
        @params << Indicators::Helper.get_parameters(all_params, 0, 12)
        @params << Indicators::Helper.get_parameters(all_params, 1, 26)
        @params << Indicators::Helper.get_parameters(all_params, 2, 9)
      when :rsi
        @params = Indicators::Helper.get_parameters(all_params, 0, 14)
      when :sto
        @params = Array.new
        @params << Indicators::Helper.get_parameters(all_params, 0, 14)
        @params << Indicators::Helper.get_parameters(all_params, 1, 3)
        @params << Indicators::Helper.get_parameters(all_params, 2, 3)
      end

      # This is a Securities gem hash.
      if data[0].is_a?(Hash)
        data = Indicators::Parser.parse_data(data)
        # Parser returns in {:date=>[2012.0, 2012.0, 2012.0], :open=>[409.4, 410.0, 414.95],} format
      else
        # Don't let calculation start on a standard array for few instruments cause it needs more specific data.
        if type == :sto
          raise MainException, 'You cannot calculate Stochastic Oscillator on array. Highs and lows are needed. Feel free Securities gem hash instead.'
        end
      end
      @output = case type
                  when :sma then Indicators::Sma.calculate(data, @params)
                  when :ema then Indicators::Ema.calculate(data, @params)
                  when :bb then Indicators::Bb.calculate(data, @params)
                  when :macd then Indicators::Macd.calculate(data, @params)
                  when :rsi then Indicators::Rsi.calculate(data, @params)
                  when :sto then Indicators::Sto.calculate(data, @params)
                end
      return @output
    end
  end

  # Class to parse a securities gem return hash.
  class Parser

    # Error handling.
    class ParserException < StandardError ; end

    def self.parse_data parameters

      usable_data = Hash.new
      transposed_hash = Hash.new
      # Such a hacky way to transpose an array.
      # FIXME: Now v.to_f converts date to float, it shouldn't.
      parameters.inject({}){|a, h|
        h.each_pair{|k,v| (a[k] ||= []) << v.to_f}
        transposed_hash = a
      }
      usable_data = transposed_hash
      # usable data is {:close => [1, 2, 3], :open => []}

      return usable_data
    end

  end
end
