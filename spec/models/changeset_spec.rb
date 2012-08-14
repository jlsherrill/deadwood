require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Changeset do
  it "should create a changeset then find it and delete it" do
    VCR.use_cassette 'create_changeset' do
      org_id = 'ACME_Corporation'
      env = Deadwood::Katello::Environment.new(:name => 'Test', :prior => 1, :organization_id => org_id)
      env.save
      changeset = Deadwood::Katello::Changeset.new(:name => 'test_changeset', :description => 'test_description', :environment_id => env.id, :organization_id => org_id)
      changeset.save
      changeset.nil?.should be_false

      changesets = Deadwood::Katello::Changeset.find(:all, :from=> "/katello/api/organizations/ACME_Corporation/environments/#{env.id}/changesets")
      changesets.nil?.should be_false
      changesets.each do |cs|
        cs.destroy
      end

      changesets = Deadwood::Katello::Changeset.find(:all, :from=> "/katello/api/organizations/ACME_Corporation/environments/#{env.id}/changesets")
      changesets.empty?.should be_true
      env.destroy
    end
  end
end
