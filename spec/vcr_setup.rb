#  Copyright (c) 2012 Chris Alfonso
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

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

