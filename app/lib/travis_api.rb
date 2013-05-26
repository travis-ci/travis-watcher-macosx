class TravisAPI
  def initialize
    base_url = NSURL.URLWithString("https://api.travis-ci.org/")
    @client = AFHTTPClient.alloc.initWithBaseURL(base_url)
    @client.setDefaultHeader("Accept", value:"application/vnd.travis-ci.2+json, */*; q=0.01")
    @client.parameterEncoding = AFJSONParameterEncoding

    if Preferences.sharedPreferences.access_token
      self.accessToken = Preferences.sharedPreferences.access_token
    end
  end

  def accessToken=(accessToken)
    @client.setDefaultHeader("Authorization", value:"token #{accessToken}")
  end

  def gitHubAuth(gitHubToken, &block)
    @client.postPath("/auth/github", parameters: { "github_token" => gitHubToken }, success:proc { |operation, replyData|
      reply = parseJSON(replyData)
      NSLog("Did GitHub auth: %@", reply)
      block.call(reply)
    }, failure:proc { |operation, error|
      NSLog("Error doing GitHub auth on Travis: %@", error)
    })
  end

  def getUserInfo(&block)
    @client.getPath("/users", parameters:nil, success:proc { |operation, replyData|
      reply = parseJSON(replyData)
      NSLog("Got user data: %@", reply)
      block.call(reply)
    }, failure:proc{ |operation, error|
      NSLog("Failed getting user data: %@", error)
    })
  end

  def parseJSON(data)
    error_ptr = Pointer.new(:object)
    NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingAllowFragments, error:error_ptr)
  end
end

