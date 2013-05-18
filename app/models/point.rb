class Point
  attr_writer :left_x, :left_y, :left_touching, :right_x, :right_y, :right_touching

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
    if @left_x > 0.4 || @left_x < -0.4
      @left_x * 100
    else
      0
    end
  end

  def thrust
    if @left_touching
      [38_000 + (-@left_y * 20_000), 0].max
    else
      0
    end
  end

  def roll
    @right_x * 10
  end

  def pitch
    -@right_y * 10
  end
end
