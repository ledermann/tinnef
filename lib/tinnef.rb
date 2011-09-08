require 'tinnef/dir_patch'

class TNEF
  # = convert
  #
  # Extract the content of a winmail.dat file and 
  # executes the given block for every single file in it
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
    Dir.mktmpdir do |dir|
      file_names = extract(content, options.merge(:dir => dir))
      file_names.each do |file_name|
        File.open("#{dir}/#{file_name}", "r") do |file|
          yield(file)
        end
      end
    end
  end
  
  def self.extract(content, options={})
    command = options[:command] || 'tnef'
    dir = options[:dir]
    
    IO.popen("#{command} -K -C #{dir}", "wb") do |f|
      f.write(content)
      f.close
      if $?.signaled?
        raise IOError, "tnef exited with signal #{$?.termsig}"
      end
      if $?.exited? && $?.exitstatus != 0
        raise IOError, "tnef exited with status #{$?.exitstatus}"
      end
    end
    
    Dir.new(dir).sort.delete_if { |file_name| File.directory?(file_name) }
  end
end