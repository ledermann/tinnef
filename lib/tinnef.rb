class TNEF
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