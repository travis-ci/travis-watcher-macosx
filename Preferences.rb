require 'singleton'

class Preferences
  
  include Singleton
  
  def initialize
    @defaults = {repos: ['travis-ci/travis-ci'], interval: 60, remote: 'http://travis-ci.org/' }
  end
  
  def [](key)
    puts "getting #{key}"
    NSUserDefaults.standardUserDefaults["de.nofail.tci.#{key}"] || @defaults[key]
  end
  
  def []=(key, value)
    puts "setting #{key} #{value}"
    NSUserDefaults.standardUserDefaults["de.nofail.tci.#{key}"] = value
    NSUserDefaults.standardUserDefaults.synchronize
  end
  
end