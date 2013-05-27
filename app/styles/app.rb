Teacup::Stylesheet.new(:app) do
  style :label,
    editable: false,
    bezeled: false,
    drawsBackground: false

  style :small_label, extends: :label,
    font: NSFont.labelFontOfSize(0)

  style :button,
    buttonType: NSMomentaryPushInButton,
    bezelStyle: NSRoundedBezelStyle
end
