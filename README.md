# tinnef

[![Build Status](https://travis-ci.org/ledermann/tinnef.png?branch=master)](https://travis-ci.org/ledermann/tinnef)
[![Code Climate](https://codeclimate.com/github/ledermann/tinnef.png)](https://codeclimate.com/github/ledermann/tinnef)

This gem handles e-mail attachments packaged in the Microsoft "application/ms-tnef" MIME type. It's a Ruby wrapper for the [tnef converter](http://tnef.sourceforge.net).

From [Wikipedia](http://en.wikipedia.org/wiki/Transport_Neutral_Encapsulation_Format): "Transport Neutral Encapsulation Format or TNEF is, despite the name, a proprietary E-mail attachment format used by Microsoft Outlook and Microsoft Exchange Server. An attached file with TNEF encoding is most often named winmail.dat or win.dat, and has a MIME type of Application/MS-TNEF."


## Requirements

### Ruby

Tested with Ruby 1.8.7, 1.9.3 and 2.0.0

### tnef

The binary of tnef is required in a current version, 1.4.6 is ok. Check if this tool already exists on your machine:

    tnef --version

It doesn't exist? You can install it:

#### Mac OS X

Using Homebrew, just do:

    brew install tnef

Using MacPorts, just do:

    sudo ports install tnef

#### Linux

There are chances that this will work:

    apt-get install tnef

Beware: On older Linux distribution, you will get a too old version of tnef, which does not work (e.g. 1.4.3 in Ubuntu Hardy), so you have to compile it by yourself. It's easy:

    wget http://sourceforge.net/projects/tnef/files/tnef/v1.4.7/tnef-1.4.7.tar.gz/download
    tar -xzvf tnef-1.4.7.tar.gz
    cd tnef-1.4.7
    ./configure
    make
    make check
    make install

#### Windows

What? I don't think this gem will work on Windows.


## Installation

    gem install tinnef

## Usage

The gem defines the class TNEF with a class method to convert a given winmail.dat file. Use it with a block like in the following example:

    require 'rubygems'
    require 'tinnef'

    content = File.new('winmail.dat').read
    TNEF.convert(content, :command => '/opt/local/bin/tnef') do |temp_file|
      unpacked_content = temp_file.read
      unpacked_filename = File.basename(temp_file.path)

      File.open("/some/path/#{unpacked_filename}", 'w') do |new_file|
        new_file.write(unpacked_content)
      end
    end


## About the naming of this gem

"Tinnef" is a german slang word for "rubbish" or "trash". TNEF => TiNnEF => Tinnef - you know?

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

This code is based on the work by Peter Collingbourne, published as part of the [alaveteli](https://github.com/sebbacon/alaveteli/blob/master/lib/tnef.rb) project.
Thank you for sharing!

Copyright (c) 2010-2011 Georg Ledermann. See MIT-LICENSE for details.
