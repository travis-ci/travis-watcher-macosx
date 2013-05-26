# Travis Watcher - Mac Edition

## Roadmap

In no particular order:

- Authentication
- Option to connect to multiple Travis installations (org/pro/custom). The only
  difference is the API endpoint and the fact that pro *requires*
  authentication.
- Show status for master branch (or other custom branch, eventually) for
  "favorite" repositories.
  - Go to latest build in web browser if clicked on.
- Ability to change notification types globally, per organization and per
  repository (notify on success, failure or change).
- If we're disconnected from Pusher/WebSockets, update with HTTP and reconnect
  to Pusher/WebSockets.
- (Auto)update

## Mockups

Menu bar:

![Menu bar mockup](mockups/menubar.png)

Preferences window:

![Preferences window mockup](mockups/preferences.png)

## Development Setup

The Travis CI Mac app uses [RubyMotion][]. In order to build the app, RubyMotion
must be installed, see their website for more information.

[RubyMotion]: http://www.rubymotion.com/

## Note on Patches/Pull Requests

1. Fork the project.
2. Make your feature addition or bug fix.
3. Add tests for it. This is important so it doesn't get broken in a future
   version unintentionally.
4. Commit. Please do not edit the version number. If you want to update it,
   please do so in a separate commit so it's easy to ignore when merging.
5. Send a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012-2013 [Travis](https://github.com/travis-ci). See LICENSE file
for details.
