# These are methods that are only called with send(). We need to "call" them
# here in order to force RubyMotion to generate stubs for them.

class MyDummyView
  private
  def dummy
    setHidden(nil)
  end
end

class MyDummyTextField < NSTextField
  private
  def dummy
    setBezeled(nil)
    setEditable(nil)
    setDrawsBackground(nil)
  end
end
