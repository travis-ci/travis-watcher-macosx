require 'singleton'

class Growl
  
  include Singleton
  
  def initialize
    @application_name = 'de.nofail.tci'
    @application_icon = load_image('tci').TIFFRepresentation
    @default_notifications = @notifications = ['notification']
    @center = NSDistributedNotificationCenter.defaultCenter
    
    send_registration!
  end
  
  def notify(title, description, options = {})
    dict = {
      ApplicationName:         @application_name,
      NotificationName:        'notification',
      NotificationTitle:       title,
      NotificationDescription: description,
      NotificationPriority:    options[:priority] || 0,
      NotificationIcon:        @application_icon
    }
    dict[:NotificationSticky] = 1 if options[:sticky]
    
    @center.postNotificationName(:GrowlNotification, object: nil, userInfo: dict, deliverImmediately: false)
  end
  
  def send_registration!
    dict = {
      ApplicationName:      @application_name,
      ApplicationIcon:      @application_icon,
      AllNotifications:     @notifications,
      DefaultNotifications: @default_notifications
    }
    
    @center.postNotificationName(:GrowlApplicationRegistrationNotification, object: nil, userInfo: dict, deliverImmediately: true)
  end
end
