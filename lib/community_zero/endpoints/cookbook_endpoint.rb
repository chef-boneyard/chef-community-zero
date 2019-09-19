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
  # The endpoint for interacting with a single cookbook.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class CookbookEndpoint < Endpoint
    # GET /cookbooks/:name
    def get(request)
      name = request.path.last
      cookbook = store.find(name)

      if cookbook = store.find(name)
        respond({
          'name'            => cookbook.name,
          'maintainer'      => cookbook.maintainer,
          'category'        => cookbook.category,
          'external_url'    => cookbook.external_url,
          'description'     => cookbook.description,
          'average_rating'  => cookbook.average_rating,
          'versions'        => store.versions(cookbook).map { |i| version_url_for(cookbook, i) },
          'latest_version'  => version_url_for(cookbook, store.latest_version(cookbook)),
          'created_at'      => cookbook.created_at,
          'updated_at'      => cookbook.upadated_at,
        })
      else
        respond(404,
          {
            'error_code' => 'NOT_FOUND',
            'error_messages' => ['Resource not found'],
          }
        )
      end
    end

    # DELETE /cookbooks/:name
    def delete(request)
      name = request.path.last

      if cookbook = store.find(name)
        store.remove(cookbook)
        respond({})
      else
        respond(404,
          {
            'error_code' => 'NOT_FOUND',
            'error_messages' => ['Resource not found'],
          }
        )
      end
    end
  end
end
