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
  it "should find a provider if a provider exists" do
    VCR.use_cassette 'provider_1_exists' do
      provider = Deadwood::Katello::Provider.find(1)
      provider.nil?.should be_false
    end
  end

  it "should find all providers if all providers exist" do
    VCR.use_cassette 'providers_all_exists' do
      providers = Deadwood::Katello::Provider.find(:all, :from=> "/katello/api/organizations/#{org_id}/providers")
      providers.nil?.should be_false
    end

  end

  it "should update a provider" do
    VCR.use_cassette 'update_provider_for_org' do
      provider = Deadwood::Katello::Provider.find(1)
      provider.attributes.delete(:provider_type)
      provider.attributes.delete(:organization_id)
      provider.attributes.delete(:created_at)
      provider.attributes.delete(:task_status_id)
      provider.attributes.delete(:sync_state)
      provider.attributes.delete(:description)
      provider.attributes.delete(:updated_at)
      provider.attributes.delete(:last_sync)
      provider.attributes.delete(:name)
      provider.update_attribute(:repository_url, 'https://cdn.redhat.tv')
      provider = Deadwood::Katello::Provider.find(1)
      (provider.repository_url.include? 'https://cdn.redhat.tv').should be_true
      provider.attributes.delete(:provider_type)
      provider.attributes.delete(:organization_id)
      provider.attributes.delete(:created_at)
      provider.attributes.delete(:task_status_id)
      provider.attributes.delete(:sync_state)
      provider.attributes.delete(:description)
      provider.attributes.delete(:updated_at)
      provider.attributes.delete(:last_sync)
      provider.attributes.delete(:name)
      provider.update_attribute(:repository_url, 'https://cdn.redhat.com')
    end
  end

  it "should create a provider" do
    VCR.use_cassette 'create_provider_for_default_org' do
      size = Deadwood::Katello::Provider.find(:all, :from=> "/katello/api/organizations/#{org_id}/providers").size
      provider = Deadwood::Katello::Provider.new(:organization_id => 'ACME_Corporation', :provider_type => 'Custom', :repository_url => 'http://repo.example.com', :name => 'test_provider_name', :description => 'Test provider description')
      provider.save
      new_size = Deadwood::Katello::Provider.find(:all, :from=> "/katello/api/organizations/#{org_id}/providers").size
      (new_size == size + 1).should be_true
      provider.destroy
    end
  end
end
