module PreferenceHelpers
  def should_set_key(defaults, key, value)
    if value == true || value == false
      defaults.should.receive(:setBool).with(value, forKey: key)
    else
      defaults.should.receive(:setObject).with(value, forKey: key)
    end
  end
end

describe Preferences do
  extend Facon::SpecHelpers
  extend PreferenceHelpers

  before do
    @userDefaults = mock('userDefaults', synchronize: nil, stringArrayForKey: [], setObject: nil, setBool: nil)
    @preferences = Preferences.new(@userDefaults)
  end

  describe "#setup_defaults" do
    it "register defaults on the user defaults" do
      @userDefaults.should.receive(:registerDefaults).with({
        "repositories" => [],
        "firehose" => false,
      })
      @preferences.setup_defaults
    end
  end

  describe "#repositories" do
    it "returns the repositories" do
      repositories = %w[travis-ci/travis-ci travis-ci/travis-mac]
      @userDefaults.should.receive(:stringArrayForKey).with("repositories").and_return(repositories)
      @preferences.repositories.should == repositories
    end
  end

  describe "#add_repository" do
    it "adds the repository" do
      should_set_key(@userDefaults, "repositories", %w[travis-ci/travis-ci])
      @preferences.add_repository("travis-ci/travis-ci")
    end

    it "synchronizes the defaults" do
      @userDefaults.should.receive(:synchronize)
      @preferences.add_repository("travis-ci/travis-ci")
    end
  end

  describe "#remove_repository" do
    it "removes the repository" do
      @userDefaults.should.receive(:stringArrayForKey).with("repositories").and_return(%w[travis-ci/travis-ci])
      should_set_key(@userDefaults, "repositories", [])
      @preferences.remove_repository("travis-ci/travis-ci")
    end

    it "synchronizes the defaults" do
      @userDefaults.should.receive(:synchronize)
      @preferences.remove_repository("travis-ci/travis-ci")
    end
  end

  describe "#firehose_enabled?" do
    it "returns true if the firehose is enabled" do
      @userDefaults.should.receive(:boolForKey).with("firehose").and_return(true)
      @preferences.firehose_enabled?.should == true
    end

    it "returns false if the firehose is disabled" do
      @userDefaults.should.receive(:boolForKey).with("firehose").and_return(false)
      @preferences.firehose_enabled?.should == false
    end
  end

  describe "#firehose_enabled=" do
    it "sets whether the firehose is enabled" do
      should_set_key(@userDefaults, "firehose", true)
      @preferences.firehose_enabled = true
    end

    it "synchronizes the defaults" do
      @userDefaults.should.receive(:synchronize)
      @preferences.firehose_enabled = true
    end
  end

  describe "#access_token" do
    it "returns the access token" do
      @userDefaults.should.receive(:stringForKey).with("access_token").and_return("foobar")
      @preferences.access_token.should == "foobar"
    end
  end

  describe "#access_token=" do
    it "sets the access token" do
      should_set_key(@userDefaults, "access_token", "foobar")
      @preferences.access_token = "foobar"
    end

    it "synchronizes the defaults" do
      @userDefaults.should.receive(:synchronize)
      @preferences.access_token = "foobar"
    end
  end
end
