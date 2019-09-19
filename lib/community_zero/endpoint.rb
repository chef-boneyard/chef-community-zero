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

module CommunityZero
  # The base class for any endpoint.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class Endpoint
    require_relative 'endpoints/cookbook_endpoint'
    require_relative 'endpoints/cookbook_versions_version_endpoint'
    require_relative 'endpoints/cookbooks_endpoint'
    require_relative 'endpoints/not_found_endpoint'
    require_relative 'endpoints/search_endpoint'

    METHODS = [:get, :put, :post, :delete].freeze

    attr_reader :server

    # Create a new endpoint.
    #
    # @param [CommunityZero::Server] server
    #   the server to respond to this endpoint
    def initialize(server)
      @server = server
    end

    # The data store for these endpoints
    #
    # @return [CommunityZero::Store]
    def store
      server.store
    end

    # Generate the URL for the given cookbook.
    #
    # @param [CommunityZero::Cookbook] cookbook
    #   the coookbook to generate the URL for
    #
    # @return [String]
    #   the URL
    def url_for(cookbook)
      "#{server.url}/cookbooks/#{cookbook.name}"
    end

    # Generate the version URL for the given cookbook and version.
    #
    # @param [CommunityZero::Cookbook] cookbook
    #   the coookbook to generate the URL for
    # @param [String]  version
    #   the version to generate a string for
    #
    # @return [String]
    #   the URL
    def version_url_for(cookbook, version)
      "#{server.url}/cookbooks/#{cookbook.name}/versions/#{version.gsub('.', '_')}"
    end

    # Call the request.
    #
    # @param [CommunityZero::Request] request
    #   the request object
    def call(request)
      m = request.method.downcase.to_sym

      # Only respond to listed methods
      unless respond_to?(m)
        allowed = METHODS.select { |m| respond_to?(m) }.map(&:upcase).join(', ')
        return [
          405,
          { 'Content-Type' => 'text/plain', 'Allow' => allowed },
          "Method not allowed: '#{request.env['REQUEST_METHOD']}'"
        ]
      end

      begin
        send(m, request)
      rescue RestError => e
        error(e.response_code, e.error)
      end
    end

    private
      def error(response_code, error)
        respond(response_code, { 'error' => error })
      end

      def respond(response_code = 200, content)
        [
          response_code,
          { 'Content-Type' => 'application/json' },
          JSON.pretty_generate(content)
        ]
      end

  end
end
