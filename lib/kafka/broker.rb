require "logger"
require "kafka/connection"
require "kafka/protocol"

module Kafka
  class Broker
    def self.connect(node_id: nil, logger:, **options)
      connection = Connection.new(logger: logger, **options)
      new(connection: connection, node_id: node_id, logger: logger)
    end

    def initialize(connection:, node_id: nil, logger:)
      @connection = connection
      @node_id = node_id
      @logger = logger
    end

    # @return [String]
    def to_s
      "#{@connection} (node_id=#{@node_id.inspect})"
    end

    # @return [nil]
    def disconnect
      @connection.close
    end

    # Fetches cluster metadata from the broker.
    #
    # @param (see Kafka::Protocol::TopicMetadataRequest#initialize)
    # @return [Kafka::Protocol::MetadataResponse]
    def fetch_metadata(**options)
      request = Protocol::TopicMetadataRequest.new(**options)

      @connection.send_request(request)
    end

    # Fetches messages from a specified topic and partition.
    #
    # @param (see Kafka::Protocol::FetchRequest#initialize)
    # @return [Kafka::Protocol::FetchResponse]
    def fetch_messages(**options)
      request = Protocol::FetchRequest.new(**options)

      @connection.send_request(request)
    end

    # Lists the offset of the specified topics and partitions.
    #
    # @param (see Kafka::Protocol::ListOffsetRequest#initialize)
    # @return [Kafka::Protocol::ListOffsetResponse]
    def list_offsets(**options)
      request = Protocol::ListOffsetRequest.new(**options)

      @connection.send_request(request)
    end

    # Produces a set of messages to the broker.
    #
    # @param (see Kafka::Protocol::ProduceRequest#initialize)
    # @return [Kafka::Protocol::ProduceResponse]
    def produce(**options)
      request = Protocol::ProduceRequest.new(**options)

      @connection.send_request(request)
    end
  end
end
