require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Template do
  let(:org_id) { 'ACME_Corporation' }
  it "should create a template, find it, update it, then delete it" do
    VCR.use_cassette 'create_template' do
      # Get the Library environment
      env = Deadwood::Katello::Environment.find(:all, :from => "/katello/api/organizations/#{org_id}/environments")[0]
      template = Deadwood::Katello::Template.new(:environment_id => env.id, :description => 'test description', :name => 'test_template_name')
      template.save!

      template = Deadwood::Katello::Template.find(template.id)
      template.nil?.should be_false

      templates = Deadwood::Katello::Template.find(:all, :from => "/katello/api/environments/#{env.id}/templates")
      templates.empty?.should be_false

      template.destroy
      templates = Deadwood::Katello::Template.find(:all, :from => "/katello/api/environments/#{env.id}/templates")
      templates.empty?.should be_true
    end
  end
end
