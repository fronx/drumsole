require 'rubygems'
require 'highline'
include HighLine::SystemExtensions

class Drumsole

  def initialize
    @timeline = ''
    @result = {}
    @quit = false
    @started = false
    @unit = nil
  end

  def scale
    100
  end

  def measure
    t1 = Time.now
    result = yield
    t2 = Time.now
    @time = @started ? (t2 - t1) * scale : 0
    @unit = @time if !@unit || @time < @unit
    @started = true
    result
  end

  def out
    puts "\n\n"
    @result.each do |k, v|
      puts "#{v}"
    end
  end

  def stroke(c)
    @timeline << '.' * @time.to_i
    @result[c] ||= ''
    i = @timeline.length - @result[c].length
    @result[c] << '.' * i + 'o'
  end

  def run
    while !@quit do
      c = measure do
        get_character
      end
      stroke(c) unless @quit = c == 27
    end
    out
  end

end

d = Drumsole.new
d.run