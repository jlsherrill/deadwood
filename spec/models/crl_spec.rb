require 'spec_helper'
require 'timecop'
require 'vcr'
require 'ruby-debug'

describe Deadwood::Katello::Crl do
  it "should retrieve the crl" do
    VCR.use_cassette 'find_crl' do
      crl = Deadwood::Katello::Crl.find(:all)
      crl.nil?.should be_false
      crl.include?("-----BEGIN X509 ").should be_true
    end
  end
end
