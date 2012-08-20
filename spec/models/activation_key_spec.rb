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

require 'spec_helper'
require 'timecop'
require 'vcr'

describe Deadwood::Katello::ActivationKey do
  let(:org_id) { "ACME_Corporation" }
  it "should create an activation key and be able to search for it and then destroy them" do
    VCR.use_cassette 'create_activation_key' do
      env = Deadwood::Katello::Environment.new(:name => 'Test', :prior => 1, :organization_id => org_id)
      env.save
      activation_key = Deadwood::Katello::ActivationKey.new(:name => 'test_activation_key', :description => 'test_description', :environment_id => env.id)
      activation_key.save
      activation_key.nil?.should be_false
      activation_keys = Deadwood::Katello::ActivationKey.find(:all, :from=> "/katello/api/organizations/#{org_id}/activation_keys")
      activation_keys.nil?.should be_false
      activation_keys.each do |key|
        key.destroy
      end
      activation_keys = Deadwood::Katello::ActivationKey.find(:all, :from=> "/katello/api/organizations/#{org_id}/activation_keys")
      env.destroy
    end
  end
end
