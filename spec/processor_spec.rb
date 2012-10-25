require "spec_helper"

describe "Dearchiver::Processor" do

  before :all do
    fixtures_dir = File.join(File.dirname(__FILE__),'fixtures')

    @tmp_dir      = File.join(File.dirname(__FILE__),'tmp')

    @extracted_test_file = File.join(@tmp_dir, "test.txt")

    @zip_file    = File.join(fixtures_dir,'test.zip')
    @rar_file    = File.join(fixtures_dir,'test.rar')
    @sevenz_file = File.join(fixtures_dir,'test.7z')
    @tar_file    = File.join(fixtures_dir,'test.tar.gz')
    @zip_file_without_extension = File.join(fixtures_dir,'testzip')

    # Create the tmp dir if doesn't exist
    Dir.mkdir(@tmp_dir) unless Dir.exists?(@tmp_dir)
  end

  after :all do
    # Delete the tmp dir if exists
    Dir.rmdir(@tmp_dir) if Dir.exists?(@tmp_dir)
  end

  after :each do
    # Clear the tmp directory
    Dir.foreach(@tmp_dir) do |f|
      unless File.directory?(File.join(@tmp_dir, f))
        File.delete(File.join(@tmp_dir, f))
      end
    end
  end

  it "should verify a zip file crc" do
    da = Dearchiver.new(:filename => @zip_file)
    da.crc_ok?.should be true
  end

  it "should verify a rar file crc" do
    da = Dearchiver.new(:filename => @rar_file)
    da.crc_ok?.should be true
  end

  it "should verify a 7z file crc" do
    da = Dearchiver.new(:filename => @sevenz_file)
    da.crc_ok?.should be true
  end

  it "should verify a gz file crc" do
    da = Dearchiver.new(:filename => @tar_file)
    da.crc_ok?.should be true
  end

  it "should verify for crc without file extension" do
    da = Dearchiver.new(:filename => @zip_file_without_extension, :archive_type => '.zip')
    da.crc_ok?.should be true
  end

  it "should extract a zip file and return a list of files" do
    da = Dearchiver.new(:filename => @zip_file)
    da.extract_to(@tmp_dir).should be_an Array
    da.list_of_files[0].should == @extracted_test_file
  end

  it "should extract a rar file and return a list of files" do
    da = Dearchiver.new(:filename => @rar_file)
    da.extract_to(@tmp_dir).should be_an Array
    da.list_of_files[0].should == @extracted_test_file
  end

  it "should extract a 7z file and return a list of files" do
    da = Dearchiver.new(:filename => @sevenz_file)
    da.extract_to(@tmp_dir).should be_an Array
    da.list_of_files[0].should == "test.txt"
  end

  it "should extract a gz file and return a list of files" do
    da = Dearchiver.new(:filename => @tar_file)
    da.extract_to(@tmp_dir).should be_an Array
    da.list_of_files[0].should == "test.txt"
  end

  it "should maintain a execution command for inspection" do
    da = Dearchiver.new(:filename => @zip_file)
    da.extract_to(@tmp_dir)
    da.execution_output.should be_a String
  end

  it "should raise an error if it is a non existing directory" do
    da = Dearchiver.new(:filename => @zip_file)
    expect { da.extract_to("/false/directory") }.to raise_error RuntimeError
  end

end