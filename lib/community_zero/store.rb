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
  # @author Seth Vargo <sethvargo@gmail.com>
  class Store
    # The number of cookbooks in the store.
    #
    # @return [Fixnum]
    #   the number of cookbooks in the store
    def size
      _cookbooks.keys.size
    end

    # The full array of cookbooks.
    #
    # @example
    #   [
    #     #<CommunityZero::Cookbook apache2>,
    #     #<CommunityZero::Cookbook apt>
    #   ]
    #
    # @return [Array<CommunityZero::Cookbook>]
    #   the list of cookbooks
    def cookbooks
      _cookbooks.map { |_,v| v[v.keys.first] }
    end

    # Query the installed cookbooks, returning those who's name matches the
    # given query.
    #
    # @param [String] query
    #   the query parameter
    #
    # @return [Array<CommunityZero::Cookbook>]
    #   the list of cookbooks that match the given query
    def search(query)
      regex = Regexp.new(query, 'i')
      _cookbooks.collect do |_, v|
        v[v.keys.first] if regex.match(v[v.keys.first].name)
      end.compact
    end

    # Delete all cookbooks in the store.
    def destroy_all
      @_cookbooks = nil
    end

    # Add the given cookbook to the cookbook store. This method's
    # implementation prohibits duplicate cookbooks from entering the store.
    #
    # @param [CommunityZero::Cookbook] cookbook
    #   the cookbook to add
    def add(cookbook)
      cookbook = cookbook.dup
      cookbook.created_at = Time.now
      cookbook.updated_at = Time.now

      entry = _cookbooks[cookbook.name] ||= {}
      entry[cookbook.version] = cookbook
    end
    alias_method :update, :add

    # Remove the cookbook from the store.
    #
    # @param [CommunityZero::Cookbook] cookbook
    #   the cookbook to remove
    def remove(cookbook)
      return unless has_cookbook?(cookbook.name, cookbook.version)
      _cookbooks[cookbook.name].delete(cookbook.version)
    end

    # Determine if the cookbook store contains a cookbook.
    #
    # @see {find} for the method signature and parameters
    def has_cookbook?(name, version = nil)
      !find(name, version).nil?
    end

    # Determine if the cookbook store contains a cookbook. If the version
    # attribute is nil, this method will return the latest cookbook version by
    # that name that exists. If the version is specified, this method will only
    # return that specific version, or nil if that cookbook at that version
    # exists.
    #
    # @param [String] name
    #   the name of the cookbook to find
    # @param [String, nil] version
    #   the version of the cookbook to search
    #
    # @return [CommunityZero::Cookbook, nil]
    #   the cookbook in the store, or nil if one does not exist
    def find(name, version = nil)
      possibles = _cookbooks[name]
      return nil if possibles.nil?

      version ||= possibles.keys.sort.last
      possibles[version]
    end

    # Return a list of all versions for the given cookbook.
    #
    # @param [String, CommunityZero::Cookbook] name
    #   the cookbook or name of the cookbook to get versions for
    def versions(name)
      name = name.respond_to?(:name) ? name.name : name
      (_cookbooks[name] && _cookbooks[name].keys.sort) || []
    end

    # Return the latest version of the given cookbook.
    #
    # @param [String, CommunityZero::Cookbook] name
    #   the cookbook or name of the cookbook to get versions for
    def latest_version(name)
      versions(name).last
    end

    private
      # All the cookbooks in the store.
      #
      # @example
      #   {
      #     'apache2' => {
      #       '1.0.0' => {
      #         'license' => 'Apache 2.0',
      #         'version' => '1.0.0',
      #         'tarball_file_size' => 20949,
      #         'file' => 'http://s3.amazonaws.com...',
      #         'cookbook' => 'http://localhost:4000/apache2',
      #         'average_rating' => nil
      #       }
      #     }
      #   }
      #
      # @return [Hash<String, Hash<String, CommunityZero::Cookbook>>]
      def _cookbooks
        @_cookbooks ||= {}
      end

  end
end
