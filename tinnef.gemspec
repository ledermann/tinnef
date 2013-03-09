# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tinnef/version"

Gem::Specification.new do |s|
  s.name        = 'tinnef'
  s.version     = Tinnef::VERSION
  s.authors     = ["Georg Ledermann"]
  s.email       = ["mail@georg-ledermann.de"]
  s.homepage    = ""
  s.summary     = %q{Ruby wrapper for tnef, a tool for unpacking 'winmail.dat' files}
  s.description = %q{Handling e-mail attachments with MIME type 'application/ms-tnef'}

  s.rubyforge_project = "."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
end
