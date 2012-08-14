require 'timecop'

describe Deadwood::Katello::Base do
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
