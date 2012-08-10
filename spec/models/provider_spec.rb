require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Organization do
  before(:each) do
    Timecop.travel(Time.local(2012, 8, 1, 13, 38, 20))
    Deadwood::Katello::Base.config = {
      :katello_user => 'admin',
      :site => 'https://10.11.230.105:443/katello/api',
      :consumer_key => 'cloud_forms',
      :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
    }
  end

  after(:each) do
    Timecop.return
  end

  it "should find a provider if a provider exists" do
    VCR.use_cassette 'provider_1_exists' do
      provider = Deadwood::Katello::Provider.find(1)
      provider.nil?.should be_false
    end
  end

  it "should find all providers if all providers exist" do
    VCR.use_cassette 'providers_all_exists' do
      providers = Deadwood::Katello::Provider.find(:all, :from=> "/katello/api/organizations/ACME_Corporation/providers")
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
      size = Deadwood::Katello::Provider.find(:all, :from=> "/katello/api/organizations/ACME_Corporation/providers").size
      provider = Deadwood::Katello::Provider.new(:organization_id => 'ACME_Corporation', :provider_type => 'Custom', :repository_url => 'http://repo.example.com', :name => 'test_provider_name', :description => 'Test provider description')
      provider.save
      new_size = Deadwood::Katello::Provider.find(:all, :from=> "/katello/api/organizations/ACME_Corporation/providers").size
      (new_size == size + 1).should be_true
      provider.destroy
    end
  end
end
