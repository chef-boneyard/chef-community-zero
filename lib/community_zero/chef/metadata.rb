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

require 'json' unless defined?(JSON)

module CommunityZero
  # A quick, short metadata parser.
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class Metadata
    # Create a new metadata class from the JSON.
    #
    # @param [String] content
    #   the raw JSON content to parse into metadata
    #
    def self.from_json(content)
      json = JSON.parse(content)

      new.tap do |instance|
        json.each do |k,v|
          instance.send(k, v)
        end
      end
    end

    # Create a new metadata class from the raw Ruby.
    #
    # @param [String] content
    #   the contents of the file to convert to a metadata entry
    def self.from_ruby(content)
      new.tap do |instance|
        instance.instance_eval(content)
      end
    end

    def method_missing(m, *args, &block)
      if args.empty?
        data[m.to_sym]
      else
        data[m.to_sym] = args.size == 1 ? args[0] : args
      end
    end

    def respond_to?(m)
      !!data[m.to_sym]
    end

    private
      def data
        @data ||= {}
      end

  end
end
