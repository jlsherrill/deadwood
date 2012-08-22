#  Copyright (c) 2012 Chris Alfonso
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

require 'spec_helper'
require 'timecop'
require 'vcr'

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

  it "should update a user" do
    VCR.use_cassette 'update_user' do
      user = Deadwood::Katello::User.new(:username => 'funzo', :email => 'spam@example.com', :password => 'secretpw', :disabled => false)
      user.save

      user = Deadwood::Katello::User.find(:all, :params => { :username => 'funzo' }).first
      user.nil?.should be_false
      user.destroy
    end
  end
end
