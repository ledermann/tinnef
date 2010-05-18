require 'tinnef/dir_patch'

class TNEF
  # = convert
  #
  # Extract the content of a winmail.dat file and 
  # call the given block for every single file in it
  # 
  # Parameters:
  #   content => Content of the winmail.dat file
  # 
  #   Options hash with this keys:
  #     :command 
  #       Full path of the tnf binary to execute (defaults to 'tnf', so it has to be in the path)
  #
  # Example:
  #   content = File.new('winmail.dat').read
  #   TNEF.convert(content, :command => '/opt/local/bin/tnef') do |temp_file|
  #     unpacked_content = temp_file.read
  #     unpacked_filename = File.basename(temp_file.path)
  # 
  #     File.open("/some/path/#{unpacked_filename}", 'w') do |new_file| 
  #       new_file.write(unpacked_content)
  #     end
  #   end
  def self.convert(content, options={}, &block)
    command = options[:command] || 'tnef'
    
    Dir.mktmpdir do |dir|
      IO.popen("#{command} -K -C #{dir}", "w") do |f|
        f.write(content)
        f.close
        if $?.signaled?
          raise IOError, "tnef exited with signal #{$?.termsig}"
        end
        if $?.exited? && $?.exitstatus != 0
          raise IOError, "tnef exited with status #{$?.exitstatus}"
        end
      end
      Dir.new(dir).sort.each do |file_name| # sort for deterministic behaviour
        if file_name != "." && file_name != ".."
          file = File.open("#{dir}/#{file_name}", "r")
          block.call(file)
        end
      end
    end
  end
end