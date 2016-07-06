require 'test_helper'

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
        assert_match(/The quick brown fox jumps over the lazy dog/, temp_file.read)
      end
    end
  end
end
