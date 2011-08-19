class ApplicationController
  
  attr_accessor :statusMenu, :statusItem, :statusImage, :reposStatusItem, :statusHighlightImage, :preferencesPanel

  # Cocoa
  
  def awakeFromNib
    @statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSSquareStatusItemLength)
    
    @statusImage = load_image('tci')
    @statusHighlightImage = load_image('tci-alt')
    
    @statusItem.setImage(@statusImage)
    @statusItem.setAlternateImage(@statusHighlightImage)
    
    @statusItem.setMenu(@statusMenu)
    @statusItem.setToolTip("Travis-CI")
    @statusItem.setHighlightMode(true)
    
    PusherConnection.instance
  end
  
  # Menu Delegate
  
  def menu(menu, willHighlightItem:item)
    if item == @reposStatusItem
      item.submenu.removeAllItems()
      Preferences.instance[:repos].each do |repo|
        mi = NSMenuItem.new
        mi.title  = repo
        mi.action = 'showStatus:'
        mi.target = self
        mi.image  = load_build_image(repo)
        
        item.submenu.addItem(mi)
      end
    end
  end
  
  # Actions
  
  def showPreferences(sender)
    NSApp.activateIgnoringOtherApps(true)
    @preferencesPanel.makeKeyAndOrderFront(self)
  end
  
  def showStatus(sender)
    alert = NSAlert.new
    alert.messageText = "Build result for #{sender.title}"
    alert.informativeText = Queue.instance.results[sender.title]
    alert.alertStyle = NSInformationalAlertStyle
    alert.addButtonWithTitle('close')
    alert.icon = load_image('tci')
    
    alert.runModal()
  end
  
end