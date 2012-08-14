require 'ruby-debug'

share_examples_for "katello api" do
  before(:each) do
    debugger
    Timecop.travel(Time.local(2012, 8, 1, 13, 38, 20))
    Deadwood::Katello::Base.config = {
      :katello_user => 'admin',
      :site => 'https://10.11.230.105:443/katello/api',
      :consumer_key => 'cloud_forms',
      :consumer_secret => 'MvhGuh1kLtOAelq5h/ebfcjW'
    }
  end

  after(:each) do
    Timecop.return
  end
end
