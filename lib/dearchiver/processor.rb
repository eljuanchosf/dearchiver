module Dearchiver
  class Processor

    attr_reader :filename
    attr_reader :archive_type

    # Initialize a new CloudDns::Client object
    #
    # options - Set of configuration options
    #
    # options[:filename]      - The complete filename (with included path) to work with.
    # options[:archive_type]  - Optional. See archive_options for recognized file types.
    #
    def initialize(options = {})
      @filename = options[:filename]
      raise ArgumentError, "Processor: :filename required!" if @filename.nil? or @filename.empty?

      @archive_type = File.extname(@filename) if valid_file_type?
      @archive_type ||= options[:archive_type]
      raise ArgumentError, "Processor: :archive_type required. :filename does not contain a recognizable extension!" if @archive_type.nil? or @archive_type.empty?
    end

    def crc_ok?
      type = File.extname(@filename)
      command = archive_options[type][:crc_check].gsub("<filename>", filename)
      crc_check = %x[#{command}]
      crc_check.include?(archive_options[type][:crc_ok]) ? true : false
    end

    private

    def archive_options
      {
          ".zip" => {
              :crc_check => "unzip -t <filename>",
              :crc_ok => "No errors detected in compressed data"
          },
          ".rar" => {
              :crc_check => "unrar t <filename>",
              :crc_ok => "All OK"
          },
          ".7z" => {
              :crc_check => "7z t <filename>",
              :crc_ok => "Everything is Ok"
          },
          ".tar.gz" => {
              :crc_check => "tar -tvzf <filename> > /dev/null",
              :crc_ok => ""
          }
      }
    end

    def valid_file_type?
      archive_options.has_key?(File.extname(@filename))
    end

  end
end