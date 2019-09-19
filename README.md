Community Zero
==============
[![Gem Version](https://badge.fury.io/rb/community-zero.png)](http://badge.fury.io/rb/community-zero)
[![Build Status](https://travis-ci.org/sethvargo/community-zero.png?branch=master)](https://travis-ci.org/sethvargo/community-zero)
[![Dependency Status](https://gemnasium.com/sethvargo/community-zero.png)](https://gemnasium.com/sethvargo/community-zero)
[![Code Climate](https://codeclimate.com/github/sethvargo/community-zero.png)](https://codeclimate.com/github/sethvargo/community-zero)

Description
-----------
Based largely off of [Chef Zero](https://github.com/jkeiser/chef-zero), Community Zero is an in-memory Chef Community Site that can be useful for testing. It IS intended to be simple, API compliant, easy to run and test. It is NOT intended to be secure, scalable, performant, scalable, persistent, or production-ready. It does not authentication or authorization (it will never throw a 400, 401, or 403). It does not persist data.

Because Community Zero run in memory, it's super fast and lightweight. This makes it perfect for testing against a "real" Community Site without mocking the entire Internet.

Installation
------------
The server can be installed as a Ruby Gem:

    $ gem install community-zero

If you're using bundler, add `community-zero` as a development dependency:

```ruby
group :development do
  gem 'community-zero'
end
```

Or in a `.gemspec`:

```ruby
s.add_development_dependency 'community-zero'
```

You can also clone the source repository and install it using `rake install`.

Usage
-----
The primary use is an in-memory fake Community site for testing. Here's a simple example:

```ruby
require 'community_zero/rspec'
```

This will create a server in the background and give you some nice hooks for accessing the data store to create and manipulate objects for testing. The best example tests are the cucumber tests packaged in the `features` directory.

Valid Options
-------------
You may currently pass the following options to the initializer:

- `host` - the host to run on
- `port` - the port to run on

CLI (Command Line)
------------------
If you don't want to use Community Zero as a library, you can start it using the included executable:

    $ community-zero

Note, this will run in the foreground.

Run `community-zero --help` to see a list of the supported flags and options:

```text
Usage: community-zero [ARGS]
    -H, --host HOST                  Host to bind to (default: 0.0.0.0)
    -p, --port PORT                  Port to listen on (default: 3389)
    -h, --help                       Show this message
        --version                    Show version
```

License and Copyright
---------------------
- Copyright 2013 Seth Vargo
- Copyright 2013 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
