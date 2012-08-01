#
#   Copyright 2011 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
require 'vcr'
require 'oauth'
require File.join(File.dirname(__FILE__), '../lib', 'deadwood')


VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr/cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

require 'oauth'
OAuth::AccessToken.class_eval do                                                                                       def request(method, path, *args)
    VCR.use_cassette('oauth', :record => :new_episodes, :match_requests_on => [:method, :uri, :body, :headers]) do
      super(method, path, *args)
    end
  end
end

