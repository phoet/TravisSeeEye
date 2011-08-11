class Preferences
  
  def initialize
    @defaults = {repos: ['travis-ci/travis-ci'], interval: 60, remote: 'http://travis-ci.org/' }
  end
  
  def [](key)
    puts "getting #{key}"
    NSUserDefaults.standardUserDefaults["de.nofail.#{key}"] || @defaults[key]
  end
  
  def []=(key, value)
    puts "setting #{key} #{value}"
    NSUserDefaults.standardUserDefaults["de.nofail.#{key}"] = value
    NSUserDefaults.standardUserDefaults.synchronize
  end
  
end