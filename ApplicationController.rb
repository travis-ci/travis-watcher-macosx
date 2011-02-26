class ApplicationController
  def applicationDidFinishLaunching(notification)
    GrowlApplicationBridge.growlDelegate = self

    @pusher = PTPusher.alloc.initWithKey(TravisToolbar::PUSHER_API_KEY, channel:TravisToolbar::PUSHER_CHANNEL_NAME)

    @pusher.addEventListener(TravisToolbar::BUILD_STARTED,  target:self, selector:"handle_event:")
    @pusher.addEventListener(TravisToolbar::BUILD_FINISHED, target:self, selector:"handle_event:")
	
	@pusher.reconnect = true;
  end

  def handle_event(event)
    GrowlApplicationBridge.notifyWithTitle(event.name,
      description:event.data["build"]["repository"]["name"],
      notificationName:"Build Information",
      iconData:NSImage.imageNamed("travis_logo.png").TIFFRepresentation,
      priority:0,
      isSticky:false,
      clickContext:nil)
  end
end