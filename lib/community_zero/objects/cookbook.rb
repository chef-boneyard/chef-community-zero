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
  # An object representation of a cookbook.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class Cookbook
    # Create a new cookbook from the given hash.
    #
    # @param [Hash] hash
    #   the hash from which to create the cookbook
    def initialize(hash = {})
      @average_rating = 3
      hash.each { |k,v| instance_variable_set(:"@#{k}",v) }
    end

    # Dump this cookbook to a hash.
    #
    # @return [Hash]
    #   the hash representation of this cookbook
    def to_hash
      methods = instance_variables.map { |i| i.to_s.gsub('@', '') }
      Hash[*methods.map { |m| [m, send(m.to_sym)] }.flatten]
    end

    def method_missing(m, *args, &block)
      if m.to_s =~ /\=$/
        value = args.size == 1 ? args[0] : args
        instance_variable_set(:"@#{m.to_s.gsub('=', '')}", value)
      else
        instance_variable_get(:"@#{m}")
      end
    end

    def respond_to?(m, include_private = false)
      instance_variables.map(&:to_s).include?("@#{m}")
    end
  end
end
