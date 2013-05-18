class AppDelegate
  def application(application, didFinishLaunchingWithOptions: launchOptions)
    controller = GamepadViewController.alloc.init

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = controller
    @window.makeKeyAndVisible

    true
  end
end
