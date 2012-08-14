require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Organization do

  it "should find an org if an org exists" do
    VCR.use_cassette 'organization_exists' do
      orgs = Deadwood::Katello::Organization.find(:all)
      (orgs.size > 0).should be_true
    end
  end

  it "should find ACME_Corporation" do
    VCR.use_cassette 'find_ACME_Corporation' do
      org = Deadwood::Katello::Organization.find(:first, :name => 'ACME_Corporation')
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
