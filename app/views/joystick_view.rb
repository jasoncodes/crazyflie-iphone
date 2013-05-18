class JoystickView
  SIZE = 100
  MARGIN = 40

  def initWithPosition(position, forFrame: frame)
    x = case position
    when :left
      MARGIN
    when :right
      frame.size.height - SIZE - MARGIN
    end
    y = (frame.size.width - SIZE - frame.origin.x)/2

    joystick = CPJoystick.alloc.initWithFrame(CGRectMake(x, y, SIZE, SIZE))
    joystick.setThumbImage(UIImage.imageNamed('handleImage.png'), andBGImage: UIImage.imageNamed('bgImage.png'))
  end
end
