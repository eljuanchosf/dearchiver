require "spec_helper"

describe "Dearchiver::Processor" do
  it "should create an instance of Dearchiver via .new" do
    Dearchiver.respond_to?(:new).should == true
    Dearchiver.new(:filename => 'foo.zip').should be_a Dearchiver::Processor
  end

  it "should create an instance if all the argmuments are correct" do
    Dearchiver.new(:filename => 'foo.bar', :archive_type => ".zip").should be_a Dearchiver::Processor
  end

  it "should raise an error if no filename is passed as an argument" do
    expect { Dearchiver.new }.to raise_error(ArgumentError)
  end

  it "should raise an error if a file type is not recognized and type not passed" do
    expect { Dearchiver.new(:filename => "foo.bar") }.to raise_error(ArgumentError)
  end

end