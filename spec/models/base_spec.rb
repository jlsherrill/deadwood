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

require 'timecop'

describe Deadwood::Katello::Base do
  it "should use_oauth? if configuration is present" do
      Deadwood::Katello::Base.config = {
        :site => 'https://10.11.230.105',
        :consumer_key => 'cloud_forms',
        :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
      }
      Deadwood::Katello::Base.use_oauth?.should be_true
  end

  context "should use_oauth? if configuration is present" do
    use_vcr_cassette "oauth_success_valid" do
      Deadwood::Katello::Organization.find(:all)
    end
  end
end
