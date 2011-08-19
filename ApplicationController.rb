class ApplicationController
  def applicationDidFinishLaunching(notification)
    @pusher = PTPusher.alloc.initWithKey(TravisToolbar::PUSHER_API_KEY, channel:TravisToolbar::PUSHER_CHANNEL_NAME)

    @pusher.addEventListener(TravisToolbar::BUILD_STARTED,  target:self, selector:"handle_event:")
    @pusher.addEventListener(TravisToolbar::BUILD_FINISHED, target:self, selector:"handle_event:")
	
	@pusher.reconnect = true;
  end

  def handle_event(event)
    puts event.name
  end
end