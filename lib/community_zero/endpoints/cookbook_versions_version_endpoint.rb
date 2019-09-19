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
  # The endpoint for interacting with a single cookbook version.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class CookbookVersionsVersionEndpoint < Endpoint
    def get(request)
      name, version = request.path[1], request.path[-1].gsub('_', '.')

      unless cookbook = store.find(name)
        return respond(404,
          {
            'error_code' => 'NOT_FOUND',
            'error_messages' => ['Resource not found'],
          }
        )
      end

      version = store.latest_version(cookbook) if version == 'latest'
      cookbook = store.find(name, version)
      respond(response_hash_for(cookbook))
    end

    private
      # The response hash for this cookbook.
      #
      # @param [CommunityZero::Cookbook] cookbook
      #   the cookbook to generate a hash for
      def response_hash_for(cookbook)
        {
          'cookbook'           => url_for(cookbook),
          'average_rating'     => cookbook.average_rating,
          'version'            => cookbook.version,
          'license'            => cookbook.license,
          'file'               => "http://s3.amazonaws.com/#{cookbook.name}.tgz",
          'tarball_file_size'  => cookbook.name.split('').map(&:ord).inject(&:+) * 25, # don't even
          'created_at'         => cookbook.created_at,
          'updated_at'         => cookbook.upadated_at,
        }
      end

  end
end
