class BatteryLabelView < UILabel
  def initWithFrame(frame)
    super

    self.textAlignment = UITextAlignmentCenter
    self.textColor = '#bfbfbf'.to_color
    self.backgroundColor = UIColor.clearColor
    self.value = nil
    self
  end

  def value=(value)
    @value = value
    self.text = "Battery Level: #{@value ? "%.2f" % [@value]: '-.--'}"
  end
end
