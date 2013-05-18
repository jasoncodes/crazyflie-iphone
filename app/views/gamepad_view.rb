class GamepadView < UIView
  attr_reader :joystick_left, :joystick_right

  def initWithFrame(frame)
    super

    @joystick_left = JoystickView.alloc.initWithPosition(:left, forFrame: self.frame)
    self.addSubview(@joystick_left)

    @joystick_right = JoystickView.alloc.initWithPosition(:right, forFrame: self.frame)
    self.addSubview(@joystick_right)

    self
  end
end
