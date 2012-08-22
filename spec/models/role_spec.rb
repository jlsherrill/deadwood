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

describe Deadwood::Katello::Role do
  let(:org_id) { 'ACME_Corporation' }
  it "creates a role" do
    VCR.use_cassette 'create_role' do
      role = Deadwood::Katello::Role.new(:name => 'test_role_name', :description => 'test role description')
      role.save
      roles = Deadwood::Katello::Role.find(:all)
      roles.last.name.include?('test_role_name').should be_true
      role.destroy
    end
  end

  it "creates a role and assigns it to a user" do
    VCR.use_cassette 'create_user_role' do
      role = Deadwood::Katello::Role.new(:name => 'test_role_name', :description => 'test role description')
      role.save

      user = Deadwood::Katello::User.new(:username => 'funzo', :email => 'spam@example.com', :password => 'secretpw', :disabled => false)
      user.save
      user_role = Deadwood::Katello::Role.new(:user_id => user.id,  :name => 'test_role', :description => 'test role description', :role_id => role.id)
      user_role.save

      roles = Deadwood::Katello::Role.find(:all, :from => "/katello/api/users/#{user.id}/roles")
      roles.empty?.should be_false
      user.destroy
      role.destroy
    end
  end

  it "creates, updates, and deletes a role" do
    VCR.use_cassette 'update_role' do
      role = Deadwood::Katello::Role.new(:name => 'test_role_name', :description => 'test role description')
      role.save
      roles = Deadwood::Katello::Role.find(:all)
      roles.last.name.include?('test_role_name').should be_true

      role.update_attributes(:name => 'test_role_name_updated')
      role.destroy
    end
  end
end
