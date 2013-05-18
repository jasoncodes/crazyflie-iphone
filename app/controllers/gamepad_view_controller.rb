class GamepadViewController < UIViewController
  def viewDidLoad
    @joystick_left = JoystickView.alloc.initWithPosition(:left, forFrame: self.view.frame)
    @joystick_left.delegate = self
    self.view.addSubview(@joystick_left)

    @joystick_right = JoystickView.alloc.initWithPosition(:right, forFrame: self.view.frame)
    @joystick_right.delegate = self
    self.view.addSubview(@joystick_right)
  end

  def cpJoystick(joystick, didUpdate: movement)
    case joystick
    when @joystick_left
      p left: movement
    when @joystick_right
      p right: movement
    end
  end
end
