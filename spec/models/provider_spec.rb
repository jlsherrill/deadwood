require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Organization do
  before(:each) do
    Timecop.travel(Time.local(2012, 8, 1, 13, 38, 20))
  end

  after(:each) do
    Timecop.return
  end

  it "should find a provider if a provider exists" do
    VCR.use_cassette 'provider_1_exists' do
      Deadwood::Katello::Base.config = {
        :katello_user => 'admin',
        :site => 'https://10.11.230.105:443/katello/api',
        :consumer_key => 'cloud_forms',
        :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
      }
      provider = Deadwood::Katello::Provider.find(1)
      provider.nil?.should be_false
    end
  end

  it "should find all providers if all providers exist" do
    VCR.use_cassette 'providers_all_exists' do
      Deadwood::Katello::Base.config = {
        :katello_user => 'admin',
        :site => 'https://10.11.230.105:443/katello/api',
        :consumer_key => 'cloud_forms',
        :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
      }
      providers = Deadwood::Katello::Provider.find(:all, :params => {:organization_id => "ACME_Corporation"})
      providers.nil?.should be_false
    end

  end

  #it "should update a provider" do
  #  VCR.use_cassette 'update_provider_for_org' do
  #    Deadwood::Katello::Base.config = {
  #      :katello_user => 'admin',
  #      :site => 'https://10.11.230.105:443/katello/api',
  #      :consumer_key => 'cloud_forms',
  #      :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
  #    }
  #    provider = Deadwood::Katello::Provider.find(1)
  #    debugger
  #    provider.update_attribute(:name, 'Red Hat Updated')
  #    provider = Deadwood::Katello::Provider.find(1)
  #    (provider.name.include? 'Red Hat Updated').should be_true
  #  end
  #end
end
