require 'socket'
require 'json'
require 'net/http'
require 'singleton'

class Queue
  
  include Singleton
  
  attr_reader :results
  
  def initialize
    @preferences = Preferences.instance
    @results = Hash.new({})
    @queue = Dispatch::Queue.new('de.nofail.tci')
    @growl = Growl.instance
    
    start_timer(@preferences[:interval], :refresh_results_for_timer)
  end
  
  def refresh_results_for_timer(timer)
    refresh_results()
  end
  
  def refresh_results(force=false)
    @growl.notify('Error', "No connection to the internet!") and return if not network_available?
    @preferences[:repos].each do |repo|
      @queue.async do
        begin
          puts url = "#{@preferences[:remote]}#{repo}.json"
          response = Net::HTTP.get_response(URI.parse(url))
          result = JSON.parse(response.body)
          if force || @results[repo].empty? || (result['last_build_finished_at'] && @results[repo]['last_build_id'] != result['last_build_id'])
            @growl.notify(repo, result['status'])
            @results[repo] = result
            puts "new build result, growl-notification for #{result}"
          else
            puts "result did not change, no growl-notification #{result}"
          end
        rescue
          puts $!
          @growl.notify('Error', "Could not get data for #{repo}")
        end
      end
    end
  end
  
  def network_available?
    Socket.getaddrinfo('travis-ci.org', nil)
  rescue
    false
  end
  
end
