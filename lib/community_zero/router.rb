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
  # The router for the Community Server.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class Router
    attr_reader :server, :routes

    def initialize(server, *routes)
      @server = server
      @routes = routes.map do |route, endpoint|
        pattern = Regexp.new("^#{route.gsub(/:[A-Za-z_]+/, '[^/]*')}$")
        [pattern, endpoint]
      end
    end

    def call(request)
      begin
        path = '/' + request.path.join('/')
        find_endpoint(path).new(server).call(request)
      rescue
        [
          500,
          { 'Content-Type' => 'text/plain' },
          "Exception raised!  #{$!.inspect}\n#{$!.backtrace.join("\n")}"
        ]
      end
    end

    private
      def find_endpoint(path)
        _, endpoint = routes.find { |route, endpoint| route.match(path) }
        endpoint || NotFoundEndpoint
      end

  end
end
