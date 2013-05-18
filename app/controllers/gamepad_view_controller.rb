class GamepadViewController < UIViewController
  def viewDidLoad
    @joystick_left = JoystickView.alloc.initWithPosition(:left, forFrame: self.view.frame)
    @joystick_left.delegate = self
    self.view.addSubview(@joystick_left)

    @joystick_right = JoystickView.alloc.initWithPosition(:right, forFrame: self.view.frame)
    @joystick_right.delegate = self
    self.view.addSubview(@joystick_right)

    @battery_label = BatteryLabelView.alloc.initWithFrame(CGRectMake(0, 20, self.view.frame.size.height, 20))
    self.view.addSubview(@battery_label)

    @host = NSBundle.mainBundle.objectForInfoDictionaryKey('host')

    connect

    @foreground_observer = App.notification_center.observe UIApplicationWillEnterForegroundNotification do |notification|
      connect
    end

    EM.add_periodic_timer 1.0 do
      if @last_received_data && @last_received_data < Time.now - 2
        @battery_label.value = nil
      end
      send(BW::JSON.generate({:ping => Time.now.to_f}))
    end

    @point = Point.new
  end

  def connect
    error_ptr = Pointer.new(:object)
    @udp_socket = GCDAsyncUdpSocket.alloc.initWithDelegate(self, delegateQueue: Dispatch::Queue.main.dispatch_object)
    @udp_socket.bindToPort(0, error: error_ptr)
    @udp_socket.beginReceiving(error_ptr)
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

  def udpSocket(socket, didReceiveData: data, fromAddress: address, withFilterContext: filterContext)
    @last_received_data = Time.now
    data = BW::JSON.parse(data.to_str)
    if data['pm']
      @battery_label.value = data['pm']['vbat']
    end
  end
end
