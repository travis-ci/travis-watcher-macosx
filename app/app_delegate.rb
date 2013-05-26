class AppDelegate
  attr_accessor :statusItem, :statusMenu

  def applicationDidFinishLaunching(notification)
    # Don't spin up the entire app if we're just running tests
    return if RUBYMOTION_ENV == 'test'

    buildStatusMenu
    buildStatusBarItem

    openPreferences(nil)
  end

  def buildStatusMenu
    self.statusMenu = NSMenu.alloc.initWithTitle("Travis CI")
    self.statusMenu.addItemWithTitle("Preferences", action: "openPreferences:", keyEquivalent: "")
    self.statusMenu.addItemWithTitle("Quit", action: "quit:", keyEquivalent: "")
  end

  def buildStatusBarItem
    self.statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSSquareStatusItemLength)
    self.statusItem.image = NSImage.imageNamed("tray.png")
    self.statusItem.alternateImage = NSImage.imageNamed("tray-alt.png")
    self.statusItem.menu = self.statusMenu
    self.statusItem.toolTip = "Travis CI"
    self.statusItem.highlightMode = true
  end

  def openPreferences(sender)
    PreferencesWindowController.sharedPrefsWindowController.showWindow(nil)
  end

  def quit(sender)
    NSApplication.sharedApplication.terminate(sender)
  end
end
