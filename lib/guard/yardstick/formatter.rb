require 'yaml'

module Guard
  # A guard plugin to run yardstick on every save
  class Yardstick
    # Formatter to colorize different output
    class Formatter < ::Yardstick::MeasurementSet
      # Wrap and yield each measurement in {MeasurementFormatter}
      #
      # @example
      #   each { |formatter| formatter.puts(io) }
      #
      # @return [undefined]
      #
      # @api public
      #
      def each(&blk)
        super { |measurement| yield MeasurementFormatter.new(measurement) }
      end

      # Warn the unsuccessful measurements, grouped by file, line, and method
      #
      # @example
      #   measurements.puts  # (outputs grouped measurements)
      #
      # @param [#puts] io
      #   optional object to puts the summary
      #
      # @return [undefined]
      #
      # @api public
      def puts(io = $stdout)
        each_group do |document, measurements|
          puts_document_header(io, document)

          measurements.each { |measurement| measurement.puts(io) }
          io.puts
        end

        puts_summary(io)
      end

      private

      # Output the document information for a group of warnings
      #
      # @example
      #   puts_document_header(io, document)
      #   # => formatter.rb:45: Formatter#puts_document_header:
      #
      # @param io [#puts] [io object for output]
      # @param document [Yardstick::Document] [document instance]
      #
      # @return [undefined]
      #
      # @api private
      #
      def puts_document_header(io, document)
        io.puts "#{document.file}:#{document.line}: #{document.path}:"
      end

      # Iterate over measurements grouped by document and skipping valid groups
      #
      # @yieldparam document [Yardstick::Document] document instance
      # @yieldparam measurements [Array<MeasurementFormatter>] measurements
      #
      # @return [undefined]
      #
      # @api private
      #
      def each_group
        group_by(&:document).each do |document, measurements|
          next if measurements.all?(&:result)
          yield(document, measurements)
        end
      end
    end
  end
end
