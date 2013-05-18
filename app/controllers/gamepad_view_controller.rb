class GamepadViewController < UIViewController
  BATTERY_WARNING_LEVEL = 3.0

  def loadView
    self.view = GamepadView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
  end

  def viewDidLoad
    self.view.joystick_left.delegate = self
    self.view.joystick_right.delegate = self

    @battery_label = BatteryLabelView.alloc.initWithFrame(CGRectMake(0, 20, self.view.frame.size.height, 20))
    self.view.addSubview(@battery_label)

    @host = NSBundle.mainBundle.objectForInfoDictionaryKey('host')

    connect

    @foreground_observer = App.notification_center.observe UIApplicationWillEnterForegroundNotification do |notification|
      connect
    end

    EM.add_periodic_timer 1.0 do
      if @last_received_data && @last_received_data < Time.now - 2
        @battery_level = nil
        @battery_label.value = nil
        @battery_label.warning = false
      end
      send(BW::JSON.generate({:ping => Time.now.to_f}))
    end

    EM.add_periodic_timer 3.0 do
      if @battery_level && @battery_level < BATTERY_WARNING_LEVEL
        AudioServicesPlayAlertSound(KSystemSoundID_Vibrate)
      end
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
    when self.view.joystick_left
      @point.left_x = movement.x
      @point.left_y = movement.y
      @point.left_touching = isTouching
    when self.view.joystick_right
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
      @battery_level = data['pm']['vbat']
      @battery_label.value = @battery_level
      @battery_label.warning = @battery_level < BATTERY_WARNING_LEVEL
    end
  end
end
