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
  # The endpoint for all cookbooks.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class CookbooksEndpoint < Endpoint
    require 'rubygems/package'
    require 'zlib'

    # GET /cookbooks
    def get(request)
      start = Integer(request.query_params['start'] || 0)
      items = Integer(request.query_params['items'] || 10)
      cookbooks = store.cookbooks[start...items] || []

      respond({
        'items' => cookbooks.collect { |cookbook|
          {
            'cookbook_name'        => cookbook.name,
            'cookbook_description' => cookbook.description,
            'cookbook'             => url_for(cookbook),
            'cookbook_maintainer'  => cookbook.maintainer
          }
        },
        'total' => store.size,
        'start' => start.to_i,
      })
    end

    # POST /cookbooks
    def post(request)
      params = Rack::Utils::Multipart.parse_multipart(request.env)
      cookbook = JSON.parse(params['cookbook'], symbolize_names: true)
      tarball = params['tarball']

      metadata = find_metadata(tarball)

      if store.find(metadata.name, metadata.version)
        respond(401,
          {
            'error_code' => 'ALREADY_EXISTS',
            'error_messages' => ['Resource already exists'],
          }
        )
      else
        respond(create_cookbook(metadata, cookbook).to_hash)
      end
    end

    private
      # Create the cookbook from the metadata.
      #
      # @param [CommunityZero::Metadata] metadata
      #   the metadata to create the cookbook from
      def create_cookbook(metadata, overrides = {})
        cookbook = Cookbook.new({
          :name        => metadata.name,
          :category    => nil,
          :maintainer  => metadata.maintainer,
          :description => metadata.description,
          :version     => metadata.version
        }.merge(overrides))

        store.add(cookbook)

        cookbook
      end

      # Parse the metadata from the tarball.
      #
      # @param [Tempfile] tarball
      #   the temporarily uploaded file
      #
      # @return [Metadata]
      def find_metadata(tarball)
        gzip = Zlib::GzipReader.new(tarball[:tempfile])
        tar = Gem::Package::TarReader.new(gzip)

        tar.each do |entry|
          if entry.full_name =~ /metadata\.json$/
            return Metadata.from_json(entry.read)
          elsif entry.full_name =~ /metadata\.rb$/
            return Metadata.from_ruby(entry.read)
          end
        end
      ensure
        tar.close
      end

  end
end
