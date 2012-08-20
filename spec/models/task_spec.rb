require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Task do
  let(:org_id) { 'ACME_Corporation' }
  it "should find tasks" do
    VCR.use_cassette 'find_template' do
      # Get the Library environment
      tasks = Deadwood::Katello::Task.find(:all, :from => "/katello/api/organizations/#{org_id}/tasks")
      tasks.empty?.should be_true
    end
  end
end
