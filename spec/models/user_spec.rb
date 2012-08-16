require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::User do
  it "should find all users" do
    VCR.use_cassette 'find_users' do
      users = Deadwood::Katello::User.find(:all)
      users.nil?.should be_false
    end
  end

  it "should find all users" do
    VCR.use_cassette 'find_admin' do
      user = Deadwood::Katello::User.find(:all, :params => { :username => 'admin' }).first
      user.username.include?('admin').should be_true
    end
  end

  it "should create a user" do
    VCR.use_cassette 'create_user' do
      user = Deadwood::Katello::User.new(:username => 'funzo', :email => 'spam@example.com', :password => 'secretpw', :disabled => false)
      user.save

      user = Deadwood::Katello::User.find(:all, :params => { :username => 'funzo' }).first
      user.nil?.should be_false
      user.destroy
    end
  end
end
