class PreferencesWindowController < DBPrefsWindowController
  def self.sharedPrefsWindowController
    Dispatch.once do
      @@sharedPrefsWindowController = self.alloc.initWithWindow(nil)
      @@sharedPrefsWindowController.windowDidLoad # Pretend we loaded a nib
    end

    @@sharedPrefsWindowController
  end

  def accountsPreferencesView
    unless defined?(@accountsPreferencesView)
      @accountsPreferencesView = AccountsPreferencesView.alloc.initWithFrame(NSZeroRect)
      # @accountsPreferencesView.setSignInTarget(self, action: 'signIn:')
    end

    @accountsPreferencesView
  end

  def signIn(target)
    gitHubAPI = GitHubAPI.new
    gitHubAPI.createAuthorization(accountsPreferencesView.username, accountsPreferencesView.password) do |authorization|
      travisAPI = TravisAPI.new
      travisAPI.gitHubAuth(authorization["token"]) do |auth|
        gitHubAPI.deleteAuthorization(authorization["id"])
        Preferences.sharedPreferences.access_token = auth["access_token"]
        travisAPI.accessToken = auth["access_token"]
        travisAPI.getUserInfo do |info|
          NSLog("Logged in on Travis as %@", info)
        end
      end
    end
  end

  ## DBPrefsWindowController

  def setupToolbar
    addView(accountsPreferencesView, label: "Accounts", image: NSImage.imageNamed("NSUserGroup"))

    accountsPreferencesView.apply_constraints

    self.crossFade = true
    self.shiftSlowsAnimation = true
  end
end
