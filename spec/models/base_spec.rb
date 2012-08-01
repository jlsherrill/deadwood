require 'spec_helper'
require 'timecop'

describe Deadwood::Katello::Base do
  before(:each) do
    Timecop.travel(Time.local(2012, 8, 1, 13, 38, 20))
  end

  after(:each) do
    Timecop.return
  end

  it "should use_oauth? if configuration is present" do
      Deadwood::Katello::Base.config = {
        :site => 'https://10.11.230.105',
        :consumer_key => 'cloud_forms',
        :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
      }
      Deadwood::Katello::Base.use_oauth?.should be_true
  end

  context "should use_oauth? if configuration is present" do
    use_vcr_cassette "oauth_success_valid" do
      Deadwood::Katello::Organization.find(:all)
    end
  end
end
