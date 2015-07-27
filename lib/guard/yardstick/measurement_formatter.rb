require 'yaml'

module Guard
  # A guard plugin to run yardstick on every save
  class Yardstick
    # Formatter to colorize different output
    class MeasurementFormatter < ::Yardstick::Measurement
      RULES_FILE = File.expand_path('../../../config/rules.yml', __dir__)
      RULES = YAML.load_file(RULES_FILE)

      # Measurement document
      #
      # @example
      #   puts measurement.document.file # => yardstick/measurement_formatter.rb
      #
      # @return [Yardstick::Document] document instance
      #
      # @api semipublic
      #
      attr_reader :document

      # Measurement result
      #
      # @example skipped item
      #   puts skipped.result # => :skip
      #
      # @example well documented measurement
      #   puts skipped.result # => true
      #
      # @example measurement that needs improvement
      #   puts skipped.result # => false
      #
      # @return [Symbol,Boolean] boolean or flag
      #
      # @api semipublic
      #
      attr_reader :result

      # Return a MeasurementFormatter instance
      #
      # @example
      #   measurement = MeasurementFormatter.new(measurement)
      #
      # @param [Yardstick::Measurement] measurement instance
      #
      # @return [Guard::Yardstick::MeasurementFormatter]
      #   the measurement formatter instance
      #
      # @api public
      def initialize(measurement)
        @document = measurement.instance_variable_get(:@document)
        @rule     = measurement.instance_variable_get(:@rule)
        @result   = measurement.instance_variable_get(:@result)
      end

      # Warns the description the measurement if it was not successful
      #
      # @example
      #   measurement.puts  # (outputs results if not successful)
      #
      # @param [#puts] io
      #   optional object to puts the summary
      #
      # @return [undefined]
      #
      # @api public
      def puts(io = $stdout)
        io.puts("  #{description}") unless ok?
      end

      # Return the reformatted Measurement description
      #
      # @example
      #   measurement.description  # => "The description"
      #
      # @return [String]
      #   the description
      #
      # @api public
      def description
        RULES.fetch(@rule.class.description)
      end
    end
  end
end
