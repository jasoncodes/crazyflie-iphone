class BatteryLabelView < UILabel
  def initWithFrame(frame)
    super

    self.textAlignment = UITextAlignmentCenter
    self.backgroundColor = UIColor.clearColor
    self.value = nil
    self.warning = false
    self
  end

  def value=(value)
    @value = value
    self.text = "Battery Level: #{@value ? "%.2f" % [@value]: '-.--'}"
  end

  def warning=(value)
    self.textColor = value ? UIColor.redColor : '#bfbfbf'.to_color
  end
end
