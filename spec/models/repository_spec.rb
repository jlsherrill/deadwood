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

describe Deadwood::Katello::Repository do
  let(:org_id) { 'ACME_Corporation' }
  it "should create a repository, read it and then delete it for ACME_Corporation" do
    VCR.use_cassette 'create_repository' do
      provider = Deadwood::Katello::Provider.new(:organization_id => 'ACME_Corporation', :provider_type => 'Custom', :repository_url => 'http://repo.example.com', :name => 'test_provider_name', :description => 'Test provider description')
      provider.save
      product = Deadwood::Katello::Product.new(:provider_id => provider.id, :name => 'Test_product', :description => 'Test description')
      product.save

      repo = Deadwood::Katello::Repository.new(:url => 'http://repo.example.com/repos', :name => 'Test_Repo', :organization_id => org_id, :product_id => product.id)
      repo.save

      repo = Deadwood::Katello::Repository.find(repo.id)
      repo.nil?.should be_false
      repo.name.include?('Test_Repo').should be_true
      repo.destroy
      provider.destroy
    end
  end
end
