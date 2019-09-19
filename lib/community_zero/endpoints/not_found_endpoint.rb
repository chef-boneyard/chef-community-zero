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
  # The general 404 endpoint.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class NotFoundEndpoint < Endpoint
    def call(request)
      error("Object not found: #{request.env['REQUEST_PATH']}")
    end

    private
      def error(message)
        [
          404,
          { 'Content-Type' => 'application/json' },
          JSON.pretty_generate({ 'error' => message })
        ]
      end

  end
end
