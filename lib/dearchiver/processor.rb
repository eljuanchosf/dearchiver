module Dearchiver
  # @author Juan Pablo Genovese
  #
  class Processor

    # Returns a String with the filename
    attr_reader :filename
    # Returns a String the archive type
    attr_reader :archive_type
    # Returns an Array of strings with the list of extracted files
    attr_reader :list_of_files
    # Returns a String with the command executed
    attr_reader :executed_command
    # Returns a String with the result of the executed command
    attr_reader :execution_output

    # Initialize a new Dearchiver::Processor object
    #
    # Possible values for **options**
    #
    #   **:filename**      - The complete filename (with included path) to work with.
    #
    #   **:archive_type**  - Optional. See archive_options for recognized file types.
    #
    # @param [Hash] options set of configuration options
    #
    # @return [Dearchiver::Processor]
    #
    def initialize(options = {})
      @filename = options[:filename]
      raise ArgumentError, "Processor: :filename required!" if @filename.nil? or @filename.empty?

      if options[:archive_type].nil? or options[:archive_type].empty?
        @archive_type = File.extname(@filename) if valid_file_type?
      end
      @archive_type ||= options[:archive_type]
      raise ArgumentError, "Processor: :archive_type required. :filename does not contain a recognizable extension!" if @archive_type.nil? or @archive_type.empty?
    end

    # Checks the CRC of the file
    #
    # Returns true if the CRC is Ok, false otherwise
    #
    # @return [Boolean]
    #
    def crc_ok?
      result = execute_command(archive_options[@archive_type][:crc_check].gsub("<filename>", filename))
      result.include?(archive_options[@archive_type][:crc_ok]) ? true : false
    end


    # Extracts the content of the compressed file to the specified directory.
    # Warning: it will overwrite the existing files without asking.
    #
    # @param [String] destination the directory with full path to extracts the files to.
    #
    # @return [Array] an array of strings with the extracted file list.
    #
    def extract_to(destination)
      raise ArgumentError, "Processor: destination is required!" if destination.nil? or destination.empty?
      raise RuntimeError, "destination directory is not valid" unless Dir.exists?(destination)

      @list_of_files = []
      result = execute_command(archive_options[@archive_type][:decompress].gsub("<filename>", filename).gsub("<extractdir>", destination))
      result.scan(archive_options[@archive_type][:file_list_regex]).each do |slice|
        # The gsub("\b","") is a hack to make the list file for unrar work.
        @list_of_files << slice.first.gsub("\b","").strip
      end
      @list_of_files
    end

    private

    def execute_command(command)
      @executed_command = command
      result = %x[#{command}]
      @execution_output = result
      result
    end

    def archive_options
      {
          ".zip" => {
              :crc_check => "unzip -t <filename>",
              :crc_ok => "No errors detected in compressed data",
              :decompress => "unzip -o <filename> -d <extractdir>",
              :file_list_regex => /(?:extracting|inflating): (.+)/,
              :compress => "zip <extractdir>/<filename> <extractdir>/<filename>"
          },
          ".rar" => {
              :crc_check => "unrar t <filename>",
              :crc_ok => "All OK",
              :decompress => "unrar x -y <filename> <extractdir>",
              :file_list_regex => /Extracting  ([\w\dA-Za-z\/\-\.]*)/,
              :compress => ""
          },
          ".7z" => {
              :crc_check => "7z t <filename>",
              :crc_ok => "Everything is Ok",
              :decompress => "7z x -y <filename> -o<extractdir>",
              :file_list_regex => /Extracting + ([\d\w\.]+)/,
              :compress => "7z a -mx9 <destination_filename> <filename>"

          },
          ".gz" => {
              :crc_check => "gunzip -t <filename>",
              :crc_ok => "",
              :decompress => "tar xvzf <filename> --overwrite -C <extractdir>",
              #/[\-rwx]+ \w+\/\w+ +\d+ [\d\-\/]+ [\d:]+ (.*)/  ->  For CRC only??
              :file_list_regex => /(.*)/,
              :compress => ""
          }
      }
    end

    def valid_file_type?
      archive_options.has_key?(File.extname(@filename))
    end

  end
end
