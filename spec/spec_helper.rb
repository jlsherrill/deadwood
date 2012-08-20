#  Copyright (c) 2012 Chris Alfonso
#                                                                                                                                                                                                                                                                            #  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights                                                                                                                                                                                              #  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is                                                                                                                                                                                                     #  furnished to do so, subject to the following conditions:
#                                                                                                                                                                                                                                                                            #  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.                                                                                                                                                                                                                       #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR                                                                                                                                                                                                #  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE                                                                                                                                                                                               #  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,                                                                                                                                                                                             #  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

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

$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib/deadwood/model/"))

require 'rubygems'
require File.join(File.dirname(__FILE__), '../lib', 'deadwood')
require 'vcr_setup'
require 'timecop'
require 'rspec'

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
  config.before(:all) do
    Timecop.travel(Time.local(2012, 8, 1, 13, 38, 20))
    Deadwood::Katello::Base.config = {
      :katello_user => 'admin',
      :site => 'https://10.11.230.105:443/katello/api',
      :consumer_key => 'cloud_forms',
      :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
    }
  end

  config.after(:each) do
    Timecop.return
  end
end
