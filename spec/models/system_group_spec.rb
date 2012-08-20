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

describe Deadwood::Katello::SystemGroup do
  let(:org_id) { 'ACME_Corporation' }
  it "creates a system" do
    VCR.use_cassette 'create_system' do
      system_group = Deadwood::Katello::SystemGroup.new(:organization_id => org_id, :name => 'Test_System_Group', :description => 'Test system group description', :max_systems=> -1)
      system_group.save!
      system_groups = Deadwood::Katello::SystemGroup.find(:all, :from => "/katello/api/organizations/#{org_id}/system_groups")
      system_groups.empty?.should be_false
      system_group.destroy
      system_groups = Deadwood::Katello::SystemGroup.find(:all, :from => "/katello/api/organizations/#{org_id}/system_groups")
      system_groups.empty?.should be_true
    end
  end

end
