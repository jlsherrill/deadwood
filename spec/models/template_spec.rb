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

describe Deadwood::Katello::Template do
  let(:org_id) { 'ACME_Corporation' }
  it "should create a template, find it, update it, then delete it" do
    VCR.use_cassette 'create_template' do
      # Get the Library environment
      env = Deadwood::Katello::Environment.find(:all, :from => "/katello/api/organizations/#{org_id}/environments")[0]
      template = Deadwood::Katello::Template.new(:environment_id => env.id, :description => 'test description', :name => 'test_template_name')
      template.save!

      template = Deadwood::Katello::Template.find(template.id)
      template.nil?.should be_false

      templates = Deadwood::Katello::Template.find(:all, :from => "/katello/api/environments/#{env.id}/templates")
      templates.empty?.should be_false

      template.destroy
      templates = Deadwood::Katello::Template.find(:all, :from => "/katello/api/environments/#{env.id}/templates")
      templates.empty?.should be_true
    end
  end
end
