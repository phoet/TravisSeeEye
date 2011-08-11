
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
    @timer = NSTimer.scheduledTimerWithTimeInterval(@preferences[:interval],
                                                    target: self,
                                                    selector: 'refresh_results:',
                                                    userInfo: nil,
                                                    repeats: true)
  end
  
  def refresh_results(timer)
    @preferences[:repos].each do |repo|
      @queue.async do
        begin
          puts url = "#{@preferences[:remote]}#{repo}.json"
          res = Net::HTTP.get_response(URI.parse(url))
          result = JSON.parse(res.body)
          if @results[repo].empty? || (result['last_build_finished_at'] && @results[repo]['last_build_id'] != result['last_build_id'])
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
  
end
