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
require 'timeout' unless defined?(Timeout)

module CommunityZero
  require_relative 'community_zero/chef'
  require_relative 'community_zero/endpoint'
  require_relative 'community_zero/errors'
  require_relative 'community_zero/object'
  require_relative 'community_zero/request'
  require_relative 'community_zero/router'
  require_relative 'community_zero/server'
  require_relative 'community_zero/store'
  require_relative 'community_zero/version'
end
