require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

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
