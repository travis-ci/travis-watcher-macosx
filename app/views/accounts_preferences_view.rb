class AccountsPreferencesView < NSView
  def initWithFrame(frame)
    super(NSMakeRect(0, 0, 549, 260)).tap do
      self.stylesheet = :accounts_preferences

      @box = subview(NSBox, :box)
      layout(@box.contentView) do
        subview(signInView, :signInView)
        subview(signedInView, :signedInView)
      end
    end
  end

  def userInfo=(userInfo)
    @userInfo = userInfo

    if @userInfo
      @avatar.image = NSImage.alloc.initWithContentsOfURL(gravatarURL)
      @nameLabel.stringValue = @userInfo["name"]
      @usernameLabel.stringValue = @userInfo["login"]
      changeToSignedInView
    else
      changeToSignInView
    end

    @userInfo
  end

  def gravatarURL
    NSURL.URLWithString("http://www.gravatar.com/avatar/#{@userInfo["gravatar_id"]}?s=60&d=mm")
  end

  def username
    @username.stringValue
  end

  def password
    @password.stringValue
  end

  def signInView
    unless defined?(@signInView)
      @signInView = NSView.new
      @signInView.hidden = false

      layout(@signInView) do
        subview(NSTextField, :username_label)
        @username = subview(NSTextField, :username_field)

        subview(NSTextField, :password_label)
        @password = subview(NSSecureTextField, :password_field)

        @username.nextKeyView = @password
        @password.nextKeyView = @username

        @signInButton = subview(NSButton, :sign_in_button)

        subview(NSTextField, :sign_in_info_label)
        subview(NSTextField, :info_label)
      end
    end

    @signInView
  end

  def signedInView
    unless defined?(@signedInView)
      @signedInView = NSView.new
      @signedInView.hidden = true

      layout(@signedInView) do
        @avatar = subview(NSImageView, :userInfoAvatar)

        @nameLabel = subview(NSTextField, :userInfoName)
        @usernameLabel = subview(NSTextField, :userInfoUsername)
        @signOutButton = subview(NSButton, :signOutButton)
      end
    end

    @signedInView
  end

  def setSignInTarget(target, action:action)
    @signInButton.target = target
    @signInButton.action = action
  end

  def setSignOutTarget(target, action:action)
    @signOutButton.target = target
    @signOutButton.action = action
  end

  private

  def changeToSignInView
    # TODO: Animate
    # TODO: Change window size (height 260 for this view seems to work well)
    self.signInView.hidden = false
    self.signedInView.hidden = true
  end

  def changeToSignedInView
    # TODO: Animate
    # TODO: Change window size (height 140 for this view seems to work well)
    self.signInView.hidden = true
    self.signedInView.hidden = false
  end
end

