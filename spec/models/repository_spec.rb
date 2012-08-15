require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Repository do
  let(:org_id) { 'ACME_Corporation' }
  it "should create a repository, read it and then delete it for ACME_Corporation" do
    VCR.use_cassette 'create_repository' do
      provider = Deadwood::Katello::Provider.new(:organization_id => 'ACME_Corporation', :provider_type => 'Custom', :repository_url => 'http://repo.example.com', :name => 'test_provider_name', :description => 'Test provider description')
      provider.save
      product = Deadwood::Katello::Product.new(:provider_id => provider.id, :name => 'Test_product', :description => 'Test description')
      product.save

      repo = Deadwood::Katello::Repository.new(:url => 'http://repo.example.com/repos', :name => 'Test_Repo', :organization_id => org_id, :product_id => product.id)
      repo.save

      repo = Deadwood::Katello::Repository.find(repo.id)
      repo.nil?.should be_false
      repo.name.include?('Test_Repo').should be_true
      repo.destroy
      provider.destroy
    end
  end
end
