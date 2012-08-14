require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::ActivationKey do
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

  it "should create an activation key and be able to search for it and then destroy them" do
    VCR.use_cassette 'create_activation_key' do
      env = Deadwood::Katello::Environment.new(:name => 'Test', :prior => 1, :organization_id => 'ACME_Corporation')
      env.save
      activation_key = Deadwood::Katello::ActivationKey.new(:name => 'test_activation_key', :description => 'test_description', :environment_id => env.id)
      activation_key.save
      activation_key.nil?.should be_false

      activation_keys = Deadwood::Katello::ActivationKey.find(:all, :from=> "/katello/api/organizations/ACME_Corporation/activation_keys")
      activation_keys.nil?.should be_false
      activation_keys.each do |key|
        key.destroy
      end
      activation_keys = Deadwood::Katello::ActivationKey.find(:all, :from=> "/katello/api/organizations/ACME_Corporation/activation_keys")
      env.destroy
    end
  end
end
