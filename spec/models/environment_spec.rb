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

describe Deadwood::Katello::Environment do
  let(:org_id) { 'ACME_Corporation' }
  it "should create an environment then delete it" do
    VCR.use_cassette 'create_find_all_environment' do
      env = Deadwood::Katello::Environment.new(:name => 'Test', :prior => 1, :organization_id => org_id)
      env.save
      env = Deadwood::Katello::Environment.find(:all, :from => "/katello/api/organizations/#{org_id}/environments")[1]
      env.nil?.should be_false
      env.name.include?('Test').should be_true
      env.destroy
    end
  end

  it "should create an environment look it up by id and then delete it" do
    VCR.use_cassette 'create_find_single_environment' do
      env = Deadwood::Katello::Environment.new(:name => 'Test', :prior => 1, :organization_id => org_id)
      env.save
      env = Deadwood::Katello::Environment.find(env.id, :from => "/katello/api/organizations/#{org_id}/environments")
      env.nil?.should be_false
      env.name.include?('Test').should be_true
      env.destroy
    end
  end

  it "should update and environment name and description" do
    VCR.use_cassette 'update_environment_name_description' do
      env = Deadwood::Katello::Environment.new(:name => 'Test', :prior => 1, :organization_id => org_id)
      env.save
      env = Deadwood::Katello::Environment.find(env.id, :from => "/katello/api/organizations/#{org_id}/environments")
      env.description = 'Test update'
      env.save
      env = Deadwood::Katello::Environment.find(env.id, :from => "/katello/api/organizations/#{org_id}/environments")
      env.nil?.should be_false
      env.description.include?('Test update').should be_true
      env.destroy
    end
  end
end
