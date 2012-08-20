require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::SystemGroup do
  let(:org_id) { 'ACME_Corporation' }
  it "creates a system" do
    VCR.use_cassette 'create_system' do
      system_group = Deadwood::Katello::SystemGroup.new(:organization_id => org_id, :name => 'Test_System_Group', :description => 'Test system group description', :max_systems=> -1)
      system_group.save!
      system_groups = Deadwood::Katello::SystemGroup.find(:all, :from => "/katello/api/organizations/#{org_id}/system_groups")
      system_groups.empty?.should be_false
      system_group.destroy
      system_groups = Deadwood::Katello::SystemGroup.find(:all, :from => "/katello/api/organizations/#{org_id}/system_groups")
      system_groups.empty?.should be_true
    end
  end

end
