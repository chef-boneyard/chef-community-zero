#
# Copyright 2013, Seth Vargo <sethvargo@gmail.com>
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'open-uri'
require 'rack'
require 'webrick'

require_relative '../community_zero'

module CommunityZero
  # A single instance of the Community Server.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class Server

    #
    # Default options to populate
    #
    DEFAULT_OPTIONS = {
      :host => '127.0.0.1',
      :port => 3389,
    }.freeze

    #
    # The list of options passed to the server.
    #
    # @return [Hash]
    #
    attr_reader :options

    #
    # Create a new Community site server.
    #
    # @param [Hash] options
    #   a list of options to pass in
    #
    # @option options [String] :host
    #   the host to listen on (default is 0.0.0.0)
    # @option options [String, Fixnum] :port
    #   the port to listen on (default is 3389)
    #
    def initialize(options = {})
      @options  = DEFAULT_OPTIONS.merge(options)
      @options[:host] = "[#{@options[:host]}]" if @options[:host].include?(':')
      @options.freeze
    end

    #
    # The data store (by default, this is just a regular store)
    #
    def store
      @store ||= Store.new
    end

    #
    # The URL for this Community Zero server.
    #
    # @return [String]
    #
    def url
      "http://#{@options[:host]}:#{@options[:port]}"
    end

    #
    # Start a Community Zero server in the current thread. You can stop this
    # server by canceling the current thread.
    #
    # @param [Boolean] publish
    #   publish the server information to STDOUT
    #
    # @return [nil]
    #   this method will block the main thread until interrupted
    #
    def start(publish = true)
      if publish
        puts <<-EOH.gsub(/^ {10}/, '')
          >> Starting Community Zero (v#{CommunityZero::VERSION})...
          >> WEBrick (v#{WEBrick::VERSION}) on Rack (v#{Rack.release}) is listening at #{url}
          >> Press CTRL+C to stop

        EOH
      end

      thread = start_background

      %w[INT TERM].each do |signal|
        Signal.trap(signal) do
          puts "\n>> Stopping Community Zero..."
          @server.shutdown
        end
      end

      # Move the background process to the main thread
      thread.join
    end

    #
    # Start a Community Zero server in a forked process. This method returns
    # the PID to the forked process.
    #
    # @param [Fixnum] wait
    #   the number of seconds to wait for the server to start
    #
    # @return [Thread]
    #   the thread the background process is running in
    #
    def start_background(wait = 5)
      @server = WEBrick::HTTPServer.new(
        :BindAddress => @options[:host],
        :Port        => @options[:port],
        :AccessLog   => [],
        :Logger      => WEBrick::Log.new(StringIO.new, 7)
      )
      @server.mount('/', Rack::Handler::WEBrick, app)

      @thread = Thread.new { @server.start }
      @thread.abort_on_exception = true
      @thread
    end

    #
    # Boolean method to determine if the server is currently ready to accept
    # requests. This method will attempt to make an HTTP request against the
    # server. If this method returns true, you are safe to make a request.
    #
    # @return [Boolean]
    #   true if the server is accepting requests, false otherwise
    #
    def running?
      if @server.nil? || @server.status != :Running
        return false
      end

      uri     = URI.join(url, 'cookbooks')
      headers = { 'Accept' => 'application/json' }

      Timeout.timeout(0.1) { !open(uri, headers).nil? }
    rescue SocketError, Errno::ECONNREFUSED, Timeout::Error
      false
    end

    #
    # Gracefully stop the Community Zero server.
    #
    # @param [Fixnum] wait
    #   the number of seconds to wait before raising force-terminating the
    #   server
    #
    def stop(wait = 5)
      Timeout.timeout(wait) do
        @server.shutdown
        @thread.join(wait) if @thread
      end
    rescue Timeout::Error
      if @thread
        $stderr.puts("Community Zero did not stop within #{wait} seconds! Killing...")
        @thread.kill
      end
    ensure
      @server = nil
      @thread = nil
    end

    # Clear out any existing entires and reset the server's contents to a
    # clean state.
    def reset!
      store.destroy_all
    end

    def to_s
      "#<#{self.class} #{url}>"
    end

    def inspect
      "#<#{self.class} @url=#{url.inspect}>"
    end

    private

    #
    # The actual application the server will respond to.
    #
    # @return [RackApp]
    #
    def app
      lambda do |env|
        request = Request.new(env)
        response = router.call(request)

        response[-1] = Array(response[-1])
        response
      end
    end

    def router
      @router ||= Router.new(self,
        ['/search',                            SearchEndpoint],
        ['/cookbooks',                         CookbooksEndpoint],
        ['/cookbooks/:name',                   CookbookEndpoint],
        ['/cookbooks/:name/versions/:version', CookbookVersionsVersionEndpoint],
      )
    end
  end
end
