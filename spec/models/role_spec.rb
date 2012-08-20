require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Role do
  let(:org_id) { 'ACME_Corporation' }
  it "creates a role" do
    VCR.use_cassette 'create_role' do
      role = Deadwood::Katello::Role.new(:name => 'test_role_name', :description => 'test role description')
      role.save
      roles = Deadwood::Katello::Role.find(:all)
      roles.last.name.include?('test_role_name').should be_true
      role.destroy
    end
  end

  it "creates a role and assigns it to a user" do
    VCR.use_cassette 'create_user_role' do
      role = Deadwood::Katello::Role.new(:name => 'test_role_name', :description => 'test role description')
      role.save

      user = Deadwood::Katello::User.new(:username => 'funzo', :email => 'spam@example.com', :password => 'secretpw', :disabled => false)
      user.save
      user_role = Deadwood::Katello::Role.new(:user_id => user.id,  :name => 'test_role', :description => 'test role description', :role_id => role.id)
      user_role.save

      roles = Deadwood::Katello::Role.find(:all, :from => "/katello/api/users/#{user.id}/roles")
      roles.empty?.should be_false
      user.destroy
      role.destroy
    end
  end

  it "creates, updates, and deletes a role" do
    VCR.use_cassette 'update_role' do
      role = Deadwood::Katello::Role.new(:name => 'test_role_name', :description => 'test role description')
      role.save
      roles = Deadwood::Katello::Role.find(:all)
      roles.last.name.include?('test_role_name').should be_true

      role.update_attributes(:name => 'test_role_name_updated')
      role.destroy
    end
  end
end
