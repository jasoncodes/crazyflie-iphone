class GamepadViewController < UIViewController
  def viewDidLoad
    @joystick_left = JoystickView.alloc.initWithPosition(:left, forFrame: self.view.frame)
    @joystick_left.delegate = self
    self.view.addSubview(@joystick_left)

    @joystick_right = JoystickView.alloc.initWithPosition(:right, forFrame: self.view.frame)
    @joystick_right.delegate = self
    self.view.addSubview(@joystick_right)

    @host = NSBundle.mainBundle.objectForInfoDictionaryKey('host')
    @udp_socket = GCDAsyncUdpSocket.alloc.initWithDelegate(self, delegateQueue: Dispatch::Queue.main)

    @point = Point.new
  end

  def cpJoystick(joystick, didUpdate: movement, touching: isTouching)
    case joystick
    when @joystick_left
      @point.left_x = movement.x
      @point.left_y = movement.y
      @point.left_touching = isTouching
    when @joystick_right
      @point.right_x = movement.x
      @point.right_y = movement.y
      @point.right_touching = isTouching
    end

    send(@point.to_json)
  end

  def send(string)
    data = "#{string}\n".dataUsingEncoding(NSUTF8StringEncoding)
    @udp_socket.sendData(data, toHost: @host, port: 0xf713, withTimeout: -1, tag: 1)
  end
end
