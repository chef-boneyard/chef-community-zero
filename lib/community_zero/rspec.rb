require 'net/http'
require 'singleton'

require_relative 'server'

module CommunityZero
  class RSpec
    undef :to_s, :inspect

    def self.method_missing(m, *args, &block)
      instance.send(m, *args, &block)
    end

    include Singleton

    extend Forwardable
    def_delegators :@server, :url, :running?, :stop, :reset!, :store, :to_s, :inspect

    attr_reader :server

    def initialize
      @server = Server.new(port: 3389)
    end

    def start
      unless @server.running?
        @server.start_background
      end

      @server
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def get(path)
      request = Net::HTTP::Get.new(path)
      http.request(request)
    end

    def post(path, body)
      request = Net::HTTP::Post.new(path)
      request.set_form_data(body)
      http.request(request)
    end

    def delete(path)
      request = Net::HTTP::Delete.new(path)
      http.request(request)
    end

    private

    def http
      @http ||= Net::HTTP.new(uri.host, uri.port)
    end
  end
end
