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

describe Deadwood::Katello::GpgKey do
  let(:org_id) { 'ACME_Corporation' }
  it "should create a gpg key, read it, updated it, and delete it for ACME_Corporation" do
    VCR.use_cassette 'create_gpg_key' do
      gpg_key = Deadwood::Katello::GpgKey.new(:name => 'Test-GPG-Key', :content => "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: GnuPG v1.4.11 (GNU/Linux)\n\nmQENBE8NW6EBCAC/ht3UujFwxol44zilXcwI8v15gf6X4u3A5Oo2FCEweQfbZw8q\nlPGjzRNHcNVO4NIZ+G1fHyWAgcs/xa4fTju4LOJU2OWfbkvGA7tlIIREkEQ9IgMI\ni0LJzsHyqhWhJ0S5POCLFyH27R0Vh2wPMwZawoomRVDsghIE8TAJVKIHICVObvGE\nVqBGSY1OHvGfZ0ZsnQv3hDmxnyywJkJ96HGVqStS2sW0YkQ77dRY0u6eSI55vwBQ\niV9dCSMs43LpoBL9pFj0ESM76G0GSGF5G9PH2b//y8ehepdS30otiqgjag5Zw76b\nqFMHFyq1o5hXJpIPiZaagU1X+wMixPOlqE5LABEBAAG0MER1bW15IFBhY2thZ2Vz\nIEdlbmVyYXRvciA8YWRtaW5Aem9vLmV4YW1wbGUuY29tPokBOAQTAQIAIgUCTw1b\noQIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ74XM4/ePsZVeCgf+L+HW\nf0K7/uzu3Q7G+aOu7qwu0iUK64SEAgtoMdjpjkq+YYxPS60zP7QS3pAzL4N31kT/\nkHQ+OJAg5Z0oegXu9mdhIenks2DaEzN6P2jAhWoRa/az5F9AaJ01WSsspsBpcAyt\n3NB2iGNtzs4v6saUz5mTp1bgmsXolzClHlTSUnjjCfuk7HgzJcCpRxb49tQ5Lo3b\n9k0XPvhhgSdiTFM+CfPl3qgHPENZqyoDOnhvKbMHZg8NCf1NLf8edlk5nWDjHti8\nVfkuCSgRzR15SgyEUU1MCQBPEYKy8U6LoOwX8Rl3+lCf9D7rReP74wSEdr9p9cFi\nSCFpN6IUJ9pN0tDU3rkBDQRPDVuhAQgAmZB+DKbraTgeW1UOYS/HWzGOR21NR3nq\nsxeG249W3OlsZbk/8BJP/DqFAhVbdxvISFkSKURoVXxUwoKx36KZHXIOgCt3vsj5\nu2mxF2ajrHBwzM8jrrNy8xdd4DplOP2D0DbuswDi5pqmd/Cd0EdC88ZIPt3Ox/GH\n4uCJOzkCRFcFRZhOT+YC+A3YaVg4UoR3AMup8K81Nm2y8q1pUy/gZvkWMONy5iDX\nlyU6enBNv+vmhumyYJT8+rPRW/ztsaBzkvpuXkQTJdWDQbigeK1hBNV5PCjyQydj\nP+sKrMxKjyyZ0rcGP1hcCqZuBHZlW0O2WJFKsZv+fY8UJfU08FeAqQARAQABiQEf\nBBgBAgAJBQJPDVuhAhsMAAoJEO+FzOP3j7GVhlsH/0emlW/Nk0bSUG4jfAeJAB7H\nKRYbr5P/YbbFLEOb4yi2DlPxUac0JoXCMLha9G9LBmQ4IL4qPHdycSlEs4cGBX6W\nxn1ti6rJ3LWm5Hb7iUBfIeuKW31thTJK7SAruiBk7g1/I55HlFW0LEfgfVUQf6hJ\n9Rnw6YVXyQAod1x/QmLWw5aQcoksHL/4eRpU74EjuKQdZMLuaherKtY6OTtEDTdm\nbEdEINVqR5hYEHgDEPPrPb5MDbQsrMEAwdWPqC2/9cgacO33/VuvXDu74X+TwE/c\nOGRCb385XPNS9KApQ4iRTZ6ccOnSJumZbeTTd9DBFwa+T1/xD96yabnaOdJqf6Y=\n=RrIG\n-----END PGP PUBLIC KEY BLOCK-----\n", :organization_id => org_id)
      gpg_key.save

      gpg_key = Deadwood::Katello::GpgKey.find(gpg_key.id)
      gpg_key.update_attributes(:name => 'Renamed-Test-GPG-Key')

      gpg_key.destroy
    end
  end
end
