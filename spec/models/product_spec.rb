require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Product do
  let(:org_id) { 'ACME_Corporation' }
  it "should create and read products for ACME_Corporation then delete them" do
    VCR.use_cassette 'read products' do
      provider = Deadwood::Katello::Provider.new(:organization_id => org_id, :provider_type => 'Custom', :repository_url => 'http://repo.example.com', :name => 'test_provider_name', :description => 'Test provider description')
      provider.save
      product = Deadwood::Katello::Product.new(:provider_id => provider.id, :name => 'Test_product', :description => 'Test description')
      product.save
      products = Deadwood::Katello::Product.find(:all, :from => "/katello/api/organizations/#{org_id}/products")
      products.nil?.should be_false
      products.empty?.should be_false
      products[0].name.include?('Test_product').should be_true
      product.organization_id = org_id
      product.destroy
      provider.destroy
      products = Deadwood::Katello::Product.find(:all, :from => "/katello/api/organizations/#{org_id}/products")
      products.empty?.should be_true

    end
  end

end
