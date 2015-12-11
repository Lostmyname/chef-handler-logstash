require "chef"
require "chef/handler"
require "socket"
require "timeout"

class Chef
  class Handler
    class Logstash < Chef::Handler
      attr_writer :tags, :host, :port, :timeout

      def initialize(options = {})
        options[:tags] ||= Array.new
        options[:timeout] ||= 15
        @tags = options[:tags]
        @timeout = options[:timeout]
        @host = options[:host]
        @port = options[:port]
      end

      def report
        # A logstash json_event looks like this:
        # {
        #   "@source":"typicall determined by logstash input def",
        #   "@type":"determined by logstash input def",
        #   "@tags":[],
        #   "@fields":{},
        #   "@timestamp":"ISO8601 of report seen by logstash",
        #   "@source_host":"host.foo.com",
        #   "@source_path":"typically the name of the log file",
        #   "@message":"escaped representation of report"
        # }
        #
        # When sending an report in native `json_event` format
        # - You are required to set everything EXCEPT @type and @timestamp
        # - @type CAN be overridden
        # - @timestamp will be ignored
        @updated_resources = []
        @updated_resources_count = 0
        if run_status.updated_resources
          run_status.updated_resources.each do |r|
            @updated_resources << r.to_s
            @updated_resources_count += 1
          end
        end
        report = Hash.new
        report["@source"] = "chef://#{run_status.node.name}/handler/logstash"
        report["@source_path"] = "#{__FILE__}"
        report["@source_host"] = run_status.node.name
        report["@tags"] = @tags
        report["@fields"] = Hash.new
        report["@fields"]["environment"] = run_status.node.chef_environment
        report["@fields"]["run_list"] = run_status.node.run_list
        report["@fields"]["updated_resources"] = @updated_resources
        report["@fields"]["updated_resources_count"] = @updated_resources_count
        report["@fields"]["elapsed_time"] = run_status.elapsed_time
        report["@fields"]["success"] = run_status.success?
        # (TODO) Convert to ISO8601
        report["@fields"]["start_time"] = run_status.start_time.to_time.iso8601
        report["@fields"]["end_time"] = run_status.end_time.to_time.iso8601
        if run_status.backtrace
          report["@fields"]["backtrace"] = run_status.backtrace.join("\n")
        else
          report["@fields"]["backtrace"] = ""
        end
        if run_status.exception
          report["@fields"]["exception"] = run_status.exception
        else
          report["@fields"]["exception"] = ""
        end
        report["@message"] = run_status.exception || "Chef client run completed in #{run_status.elapsed_time}"

        begin
          Timeout::timeout(@timeout) do
            json = report.to_json
            ls = TCPSocket.new "#{@host}" , @port
            ls.puts json
            ls.close
          end
        rescue Exception => e
          Chef::Log.info("Failed to write to #{@host} on port #{@port}: #{e.message}")
        end
      end
    end
  end
end
