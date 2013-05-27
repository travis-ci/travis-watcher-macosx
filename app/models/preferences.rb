class Preferences
  def self.sharedPreferences
    Dispatch.once do
      @@sharedPreferences = Preferences.new(NSUserDefaults.standardUserDefaults)
    end

    @@sharedPreferences
  end

  def initialize(userDefaults)
    @user_defaults = userDefaults
  end

  def setup_defaults
    @user_defaults.registerDefaults({
      "repositories" => [],
      "firehose" => false,
    })
  end

  def repositories
    @user_defaults.stringArrayForKey("repositories") || []
  end

  def add_repository(slug)
    unless self.repositories.containsObject(slug)
      self.repositories = self.repositories.arrayByAddingObject(slug)
    end
  end

  def remove_repository(slug)
    repositories = self.repositories.mutableCopy
    repositories.removeObject(slug)
    self.repositories = repositories
  end

  def firehose_enabled?
    @user_defaults.boolForKey("firehose")
  end

  def firehose_enabled=(enable)
    @user_defaults.setBool(enable, forKey: "firehose")
    @user_defaults.synchronize
  end

  def access_token
    @user_defaults.stringForKey("access_token")
  end

  def access_token=(access_token)
    @user_defaults.setObject(access_token, forKey: "access_token")
    @user_defaults.synchronize
  end

  private

  def repositories=(repositories)
    @user_defaults.setObject(repositories, forKey: "repositories")
    @user_defaults.synchronize
  end
end
