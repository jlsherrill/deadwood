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

require 'spec_helper'
require 'timecop'
require 'vcr'

describe Deadwood::Katello::Organization do
  let(:org_id) { "ACME_Corporation" }
  it "should find an org if an org exists" do
    VCR.use_cassette 'organization_exists' do
      orgs = Deadwood::Katello::Organization.find(:all)
      (orgs.size > 0).should be_true
    end
  end

  it "should find ACME_Corporation" do
    VCR.use_cassette 'find_ACME_Corporation' do
      org = Deadwood::Katello::Organization.find(:first, :name => org_id)
      org.nil?.should be_false
    end
  end

  it "should find the default organization if default organization exists" do
    VCR.use_cassette 'organization_default_exists' do
      org = Deadwood::Katello::Organization.find(:all).first
      org.nil?.should be_false
      (org.id == 1).should be_true
    end
  end

  it "should find default organization by id if the organization exists" do
    VCR.use_cassette 'organization_1_exists' do
      default_org = Deadwood::Katello::Organization.find(:all).first
      org = Deadwood::Katello::Organization.find(default_org.cp_key)
      org.nil?.should be_false
    end
  end

  it "should update the default organization name if the organization exists" do
    VCR.use_cassette 'organization_update' do
      default_org = Deadwood::Katello::Organization.find(:all).first

      # Need to remove the attributes that are protected by katello
      default_org.attributes.delete(:task_id)
      default_org.attributes.delete(:service_levels)
      default_org.attributes.delete(:updated_at)
      default_org.attributes.delete(:created_at)
      default_org.attributes.delete(:cp_key)
      # Make our description update
      default_org.update_attribute(:description, "Updated description")
      default_org = Deadwood::Katello::Organization.find(:all).first
      default_org.description.include?("Updated description").should be_true
    end
  end

  it "should create an organization" do
    VCR.use_cassette 'organization_create' do
      org = Deadwood::Katello::Organization.new({:name => 'Test_Org_Name', :description => 'Test Description'})
      created = org.save
      created.should be_true
      org = Deadwood::Katello::Organization.find('Test_Org_Name')
      Deadwood::Katello::Organization.delete(org.name)
    end
  end
end
