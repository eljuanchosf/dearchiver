require "spec_helper"

describe "Dearchiver::Processor" do

  before :all do
    @test_file = File.join(File.dirname(__FILE__),'fixtures','test.zip')
  end

  it "should verify for crc" do
    da = Dearchiver.new(:filename => @test_file)
    da.crc_ok?.should be true
  end

end