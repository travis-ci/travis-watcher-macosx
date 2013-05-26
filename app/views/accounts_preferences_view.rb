class AccountsPreferencesView < NSView
  def initWithFrame(frame)
    # Height: 260
    super(NSMakeRect(0, 0, 549, 140)).tap do
      self.stylesheet = :accounts_preferences

      @box = subview(NSBox, :box)
      layout(@box.contentView) do
        subview(signInView, :signInView)
        subview(signedInView, :signedInView)
      end

      self.userInfo = {
        "correct_scopes" => true,
        "email" => "me@henrikhodne.com",
        "gravatar_id" => "0fd80494679214743a967d583420a731",
        "id" => "444",
        "is_syncing" => "0",
        "locale" => "en",
        "login" => "henrikhodne",
        "name" => "Henrik Hodne",
        "synced_at" => "2013-05-25T12:55:28Z",
      }
    end
  end

  def userInfo=(userInfo)
    @userInfo = userInfo

    @avatar.image = NSImage.alloc.initWithContentsOfURL(gravatarURL)
    @nameLabel.stringValue = @userInfo["name"]
    @usernameLabel.stringValue = @userInfo["login"]
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
      @signInView.hidden = true

      layout(@signInView) do
        subview(NSTextField, :username_label)
        @username = subview(NSTextField, :username_field)

        subview(NSTextField, :password_label)
        @password = subview(NSSecureTextField, :password_field)

        @username.nextKeyView = @password
        @password.nextKeyView = @username

        @signInButton = subview(NSButton, :sign_in_button)

        @signInButton.target = self
        @signInButton.action = "signIn:"

        subview(NSTextField, :sign_in_info_label)
        subview(NSTextField, :info_label)
      end
    end

    @signInView
  end

  def signedInView
    unless defined?(@signedInView)
      @signedInView = NSView.new
      @signedInView.hidden = false

      layout(@signedInView) do
        @avatar = subview(NSImageView, :userInfoAvatar)

        @nameLabel = subview(NSTextField, :userInfoName)
        @usernameLabel = subview(NSTextField, :userInfoUsername)
        @signOutButton = subview(NSButton, :signOutButton)
        @signOutButton.target = self
        @signOutButton.action = "signOut:"
      end
    end

    @signedInView
  end

  def setSignInTarget(target, action:action)
    return
    @signInButton.target = target
    @signInButton.action = action
  end

  def signIn(sender)
    signInAnimation = {
      NSViewAnimationTargetKey => signInView,
      NSViewAnimationEffectKey => NSViewAnimationFadeOutEffect,
    }

    signedInAnimation = {
      NSViewAnimationTargetKey => signedInView,
      NSViewAnimationEffectKey => NSViewAnimationFadeInEffect,
    }

    animation = NSViewAnimation.alloc.initWithViewAnimations([signInAnimation, signedInAnimation])
    animation.duration = 0.1
    animation.animationCurve = NSAnimationEaseIn

    Dispatch::Queue.main.async do
      animation.startAnimation
    end
  end

  def signOut(sender)
  end
end

