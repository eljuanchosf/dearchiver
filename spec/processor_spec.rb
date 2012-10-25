require "spec_helper"

describe "Dearchiver::Processor" do

  before :all do
    @test_file_with_extension    = File.join(File.dirname(__FILE__),'fixtures','test.zip')
    @test_file_without_extension = File.join(File.dirname(__FILE__),'fixtures','testzip')
  end

  it "should verify for crc with file extension" do
    da = Dearchiver.new(:filename => @test_file_with_extension)
    da.crc_ok?.should be true
  end

  it "should verify for crc without file extension" do
    da = Dearchiver.new(:filename => @test_file_without_extension, :archive_type => '.zip')
    da.crc_ok?.should be true
  end


end