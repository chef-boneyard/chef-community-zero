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
  # A singleton request.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class Request
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def base_uri
      @base_uri ||= "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
    end

    def method
      @env['REQUEST_METHOD']
    end

    def path
      @path ||= env['PATH_INFO'].split('/').select { |part| part != "" }
    end

    def body=(body)
      @body = body
    end

    def body
      @body ||= env['rack.input'].read
    end

    def query_params
      @query_params ||= begin
        params = Rack::Request.new(env).GET
        params.keys.each do |key|
          params[key] = URI.unescape(params[key])
        end
        params
      end
    end
  end
end

