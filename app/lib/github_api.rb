class GitHubAPI
  def initialize
    base_url = NSURL.URLWithString("https://api.github.com/")
    @client = AFHTTPClient.alloc.initWithBaseURL(base_url)
    @client.setDefaultHeader("Accept", value:"application/vnd.github.beta+json")
    @client.parameterEncoding = AFJSONParameterEncoding
  end

  def createAuthorization(username, password, &block)
    @client.setAuthorizationHeaderWithUsername(username, password:password)

    @client.postPath("/authorizations", parameters: { "scopes" => [ "user:email", "public_repo" ], "note" => "Temporary token to identify on travis-ci.org" }, success:-> (operation, replyData) {
      error_ptr = Pointer.new(:object)
      reply = NSJSONSerialization.JSONObjectWithData(replyData, options:NSJSONReadingAllowFragments, error:error_ptr)

      block.call(reply)
    }, failure:-> (operation, error) {
      NSLog("WARNING: GitHub authentication failed: %@", error)
    })
  end

  def deleteAuthorization(id)
    @client.deletePath("/authorizations/#{id}", parameters:nil, success:-> (operation, reply) {
      NSLog("Deleted GitHub access token")
    }, failure:-> (operation, error) {
      NSLog("WARNING: Couldn't delete GitHub access token: %@", error)
    })
  end
end
