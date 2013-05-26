module Teacup
  class Stylesheet
    def constrain_inset(x, y)
      [
        constrain_left(x),
        constrain_right(-x),
        constrain_top(y),
        constrain_bottom(-y),
      ]
    end

    def field_label_constraints(field)
      [
        constrain_left(25),
        constrain_height(17),
        constrain_width(65),
        constrain(:baseline).equals(field, :baseline),
      ]
    end

    def field_constraints(label, row:row)
      [
        constrain_height(22),
        constrain_right(-25),
        constrain(:top).equals(:sign_in_info_label, :bottom).plus(8 + row * 28),
        constrain(:leading).equals(label, :trailing).plus(8),
      ]
    end
  end
end

Teacup::Stylesheet.new(:accounts_preferences) do
  import :app

  style :box,
    title: "Travis-CI.org Login",
    constraints: constrain_inset(25, 24)

  style :signInView, constraints: [ :full ]

  style :field_label, extends: :label,
    alignment: NSRightTextAlignment

  style :username_label, extends: :field_label,
    stringValue: "Username",
    constraints: field_label_constraints(:username_field)

  style :username_field,
    constraints: field_constraints(:username_label, row:0)


  style :password_label, extends: :field_label,
    stringValue: "Password",
    constraints: field_label_constraints(:password_field)

  style :password_field,
    constraints: field_constraints(:password_label, row:1)

  style :sign_in_button, extends: :button,
    title: "Sign In",
    constraints: [
      constrain_height(32),
      constrain(:left).equals(:password_field, :left),
      constrain_below(:password_field),
      constrain_width(90),
    ]

  style :sign_in_info_label, extends: :label,
    stringValue: "Use your GitHub details to sign in.",
    constraints: [
      constrain_top(24),
      constrain_left(25),
      constrain_right(-25),
      constrain_height(17),
    ]

  style :info_label, extends: :small_label,
    stringValue: "We need your GitHub login information to identify you. This information will not be sent to Travis CI, only to GitHub.",
    constraints: [
      constrain(:width).equals(:superview, :width).minus(50),
      constrain_center_x,
      constrain_bottom(-24),
      constrain_height(30),
    ]


  style :signedInView, constraints: [ :full ]

  style :userInfoAvatar,
    editable: false,
    constraints: [
      constrain_center_y,
      constrain_height(40),
      constrain_width(40),
      constrain_left(15),
    ]

  style :userInfoName, extends: :label,
    font: NSFont.boldSystemFontOfSize(0),
    constraints: [
      constrain(:top).equals(:userInfoAvatar, :top),
      constrain(:left).equals(:userInfoAvatar, :right).plus(8),
      constrain(:right).equals(:signOutButton, :left).minus(8),
      constrain_height(17),
    ]

  style :userInfoUsername, extends: :small_label,
    constraints: [
      constrain(:bottom).equals(:userInfoAvatar, :bottom),
      constrain(:left).equals(:userInfoName, :left),
      constrain(:right).equals(:userInfoName, :right),
      constrain_height(17),
    ]

  style :signOutButton, extends: :button,
    title: "Sign Out",
    constraints: [
      constrain_right(-15),
      constrain_width(90),
      constrain_height(31),
      constrain_center_y,
    ]
end

