require 'test_helper'

class TestDir < Test::Unit::TestCase
  def test_mktmpdir_path
    dir = Dir.mktmpdir
    
    assert_match /^\/var\/folders/, dir
    assert_equal true, File.directory?(dir)
  end
  
  def test_mktmpdir_block
    directory = ''
    Dir.mktmpdir do |dir|
      directory = dir
    end

    assert_match /^\/var\/folders/, directory
    assert_equal false, File.directory?(directory)
  end
end

class TestTinnef < Test::Unit::TestCase
  def setup
    @content = File.new(File.dirname(__FILE__) + '/fixtures/quick-winmail.dat').read
  end
  
  def test_file_names
    files = []
    TNEF.convert(@content) do |temp_file|
      files << File.basename(temp_file.path)
    end
    
    assert_equal %w(quick.doc quick.html quick.pdf quick.txt quick.xml), files
  end
  
  def test_content
    TNEF.convert(@content) do |temp_file|
      if File.basename(temp_file.path) == 'quick.txt'
        assert_match /The quick brown fox jumps over the lazy dog/, temp_file.read
      end
    end
  end
end
