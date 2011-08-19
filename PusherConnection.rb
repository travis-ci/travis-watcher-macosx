require 'socket'
require 'json'
require 'net/http'
require 'singleton'

class PusherConnection
  
  include Singleton
  
  PUSHER_API_KEY = "23ed642e81512118260e"
  PUSHER_CHANNEL_NAME = "repositories"
  
  BUILD_STARTED  = "build:started"
  BUILD_FINISHED = "build:finished"
  
  attr_reader :results
  
  def initialize
    @growl = Growl.instance
    
    @pusher = PTPusher.alloc.initWithKey(PUSHER_API_KEY, channel:PUSHER_CHANNEL_NAME)
    
    @pusher.addEventListener(BUILD_STARTED,  target:self, selector:"handle_started:")
    @pusher.addEventListener(BUILD_FINISHED, target:self, selector:"handle_finished:")
    
    @pusher.reconnect = true;
  end
  
  def handle_started(event)
    result = Result.new(event.data)
    @growl.notify(result.name, 'Starting build!')
  end
  
  def handle_finished(event)
    result = Result.new(event.data)
    @growl.notify(result.name, "Finished build with status: #{result.status}")
  end
end
