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
  # The endpoint for searching for cookbooks.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class SearchEndpoint < Endpoint
    # GET /search?q=QUERY
    def get(request)
      q = request.query_params['q'].to_s
      start = Integer(request.query_params['start'] || 0)
      items = Integer(request.query_params['items'] || 10)
      cookbooks = store.search(q)[start...items] || []

      respond({
        'items' => cookbooks.collect { |cookbook|
          {
            'cookbook_name'        => cookbook.name,
            'cookbook_description' => cookbook.description,
            'cookbook'             => url_for(cookbook),
            'cookbook_maintainer'  => cookbook.maintainer
          }
        },
        'total' => cookbooks.size,
        'start' => start,
      })
    end
  end
end
