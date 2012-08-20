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

require 'active_resource'
require File.join(File.dirname(__FILE__), 'deadwood/model', 'base')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'activation_key')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'changeset')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'consumer')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'crl')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'entitlement')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'environment')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'errata')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'gpg_key')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'organization')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'pool')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'product')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'provider')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'repository')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'role')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'status')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'subscription')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'system')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'system_group')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'task')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'template')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'user')
require File.join(File.dirname(__FILE__), 'deadwood/model', 'version')
require File.join(File.dirname(__FILE__), 'deadwood', 'active_resource_oauth_client.rb')
