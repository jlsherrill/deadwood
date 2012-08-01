require 'spec_helper'
require 'timecop'
require 'vcr'

describe Deadwood::Katello::Organization do
  before(:each) do
    Timecop.travel(Time.local(2012, 8, 1, 13, 38, 20))
  end

  after(:each) do
    Timecop.return
  end

  it "should find an org if an org exists" do
    VCR.use_cassette 'organization_exists' do
      #Deadwood::Katello::Base.site = 'https://10.11.230.105:443/katello/api'
      Deadwood::Katello::Base.config = {
        :site => 'https://10.11.230.105:443/katello/api',
        :consumer_key => 'cloud_forms',
        :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
      }
      orgs = Deadwood::Katello::Organization.find(:all)
      (orgs.size > 0).should be_true
    end
  end
end
