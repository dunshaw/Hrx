if !(RUBY_PLATFORM =~ /w32/).nil? 


require 'cucumber/formatter/html'
require 'cucumber/formatter/console'
module Cucumber
  module Ast
    module HasSteps #:nodoc:
      def backtrace_line(step_name = "#{@keyword}: #{name}", line = self.line)
        step_name = step_name.encode("utf-8") 
        "#{location.on_line(line)}:in `#{step_name}'"
      end
    end
  end
end




module Cucumber
  module Formatter
    module Console
      def print_exception(e, status, indent)
        message = "#{e.message} (#{e.class})"
        if ENV['CUCUMBER_TRUNCATE_OUTPUT']
          message = linebreaks(message, ENV['CUCUMBER_TRUNCATE_OUTPUT'].to_i)
        end
        e.backtrace.collect! do|bt|
          bt.encode("utf-8")
        end
        string = "#{message}\n#{e.backtrace.join("\n")}".indent(indent)
        @io.puts(format_string(string, status))
      end
      def print_stats(features, options)
        @failures = runtime.scenarios(:failed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
        @failures.collect! { |s| (s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }

        if !@failures.empty?
          @io.puts format_string("Failing Scenarios:", :failed)
          @failures.each do |failure|
            profiles_string = options.custom_profiles.empty? ? '' : (options.custom_profiles.map{|profile| "-p #{profile}" }).join(' ') + ' '
            source = options[:source] ? format_string(" # Scenario: " + failure.name, :comment) : ''
            file_colon_line = failure.file_colon_line.encode("utf-8")
            @io.puts format_string("cucumber #{profiles_string}" + file_colon_line, :failed) + source
          end
          @io.puts
        end

        @io.puts scenario_summary(runtime) {|status_count, status| format_string(status_count, status)}
        @io.puts step_summary(runtime) {|status_count, status| format_string(status_count, status)}

        @io.puts(format_duration(features.duration)) if features && features.duration

        @io.flush
      end
    end
  end
end

module Cucumber
  module Formatter
    class Html
       def build_exception_detail(exception)
        backtrace = Array.new
        @builder.div(:class => 'message') do
          message = exception.message
          if defined?(RAILS_ROOT) && message.include?('Exception caught')
            matches = message.match(/Showing <i>(.+)<\/i>(?:.+) #(\d+)/)
            backtrace += ["#{RAILS_ROOT}/#{matches[1]}:#{matches[2]}"] if matches
            matches = message.match(/<code>([^(\/)]+)<\//m)
            message = matches ? matches[1] : ""
          end

          unless exception.instance_of?(RuntimeError)
            message = "#{message} (#{exception.class})"
          end

          @builder.pre do
            @builder.text!(message)
          end
        end
        @builder.div(:class => 'backtrace') do
          @builder.pre do
            backtrace = exception.backtrace
            backtrace.delete_if { |x| x =~ /\/gems\/(cucumber|rspec)/ }
            
            backtrace.collect! do |b|
               b.encode("utf-8")
            end
            @builder << backtrace_line(backtrace.join("\n"))
          end
        end
        extra = extra_failure_content(backtrace)
        @builder << extra unless extra == ""
      end
    end
  end
end

end
