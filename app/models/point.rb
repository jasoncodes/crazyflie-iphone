class Point
  attr_writer :left_x, :left_y, :right_x, :right_y

  def initialize
    @left_x = 0
    @left_y = 0
    @right_x = 0
    @right_y = 0
  end

  def to_json
    BW::JSON.generate({
      :point => {
        :yaw => yaw,
        :thrust => thrust,
        :roll => roll,
        :pitch => pitch,
      }
    })
  end

  private

  def yaw
    @left_x
  end

  def thrust
    [-@left_y * 60_000, 0].max
  end

  def roll
    @right_x
  end

  def pitch
    @right_y
  end
end
