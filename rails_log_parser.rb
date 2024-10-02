#!/usr/bin/env ruby

begin
  gem "colorize"
  gem "awesome_print"
rescue Gem::LoadError
  system 'gem install colorize awesome_print'
  Gem.clear_paths
end

class String
  def uncolor
    self.gsub(/\e\[([;\d]+)?m/, '')
  end

  def insert(str)
    stripped = self.lstrip
    space_length = self.length - stripped.length
    ' ' * space_length + str + stripped
  end
end

require 'ostruct'
require 'colorize'
require 'awesome_print'
require 'json'

Flags = OpenStruct.new(
  params: false,
  marker: false,
  backtrace: false
)

begin
  options = {
    sql: false,
    ssh: false,
    'only-path': false
  }

  while opt = ARGV.shift
    options[opt.gsub('--', '').to_sym] = true
  end

  ARGF.each_line do |line|
    line = line.gsub(/e\[(d+)m/, '')

    if !options[:ssh]
      if (line =~ /Parameters.*}$/)
        print(line)
        next
      end

      Flags.params = true if line =~ /^\s*Parameters/

      if Flags.params
        Flags.params = false if line =~ /^}/

        print line
        next
      end

      if line =~ /Error/
        print(line.light_red)
        Flags.backtrace = true
        next
      end

      if Flags.backtrace
        Flags.backtrace = false if line =~ /^$/ || line =~ /Started.*?"\/(?!assets)/
        print(line.light_red) unless line =~ /[\(\)]/
        next
      end
    end

    print case
    when line =~ /Started.*?"\/(?!assets)/ then [?\n*2, line.gsub(/" for.*$/, '"').light_blue].join
    when line =~ /Processing/ then line.green
    when line =~ /Render/
      time = line.match(/\(Duration: (\d+.*) \|/)&.captures&.first.to_s
      time = time.to_i > 1000 ? time.red : time.light_yellow
      print [line.gsub(/\(Duration:.*$/, '').chop.light_cyan, time].join('')
      print "\n"
    when options[:ssh] && line =~ /Parameters/
      ap(JSON.parse(line.gsub(/^\s*Parameters:/, '').gsub('=>', ':'))) rescue nil
      print "\n"
    when line =~ /Unpermitted parameters: (.*)/
      ['Unpermitted parameters: '.light_red,  $1.light_yellow, ?\n].join
    when options[:sql] && line =~ /\([\d.]*ms\)/i
      print "\n" unless options[:'only-path']
      line.uncolor =~ /(^.*)\(([\d.]+)ms\)(.*)/
      print $1.uncolor.insert(' SQL '.white)

      time = $2.to_f > 100 ? $2.red : $2.light_yellow
      print '(%s ms)' % time
      print $3.light_magenta unless options[:'only-path']
      print "\n"
    when options[:sql] && line =~ /Query Trace|↳/ then print line.uncolor.light_yellow + "\n"
    end
  end
rescue Errno::EPIPE, SystemExit, Interrupt
  puts "\n"*2 + " "*20 + "Good bye!"
  exit 0
end
