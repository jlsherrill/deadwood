#  Copyright (c) 2012 Chris Alfonso
#                                                                                                                                                                                                                                                                            #  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights                                                                                                                                                                                              #  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is                                                                                                                                                                                                     #  furnished to do so, subject to the following conditions:
#                                                                                                                                                                                                                                                                            #  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.                                                                                                                                                                                                                       #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR                                                                                                                                                                                                #  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE                                                                                                                                                                                               #  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,                                                                                                                                                                                             #  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

require 'spec_helper'
require 'timecop'
require 'vcr'

describe Deadwood::Katello::Changeset do
  let(:org_id) { "ACME_Corporation" }
  it "should create a changeset then find it and delete it" do
    VCR.use_cassette 'create_changeset' do
      env = Deadwood::Katello::Environment.new(:name => 'Test', :prior => 1, :organization_id => org_id)
      env.save
      changeset = Deadwood::Katello::Changeset.new(:name => 'test_changeset', :description => 'test_description', :environment_id => env.id, :organization_id => org_id)
      changeset.save
      changeset.nil?.should be_false

      changesets = Deadwood::Katello::Changeset.find(:all, :from=> "/katello/api/organizations/#{org_id}/environments/#{env.id}/changesets")
      changesets.nil?.should be_false
      changesets.each do |cs|
        cs.destroy
      end

      changesets = Deadwood::Katello::Changeset.find(:all, :from=> "/katello/api/organizations/#{org_id}/environments/#{env.id}/changesets")
      changesets.empty?.should be_true
      env.destroy
    end
  end
end
