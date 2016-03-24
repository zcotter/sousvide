defmodule Sousvide do
  @target_temperature = 51.667

  def cook do
    power = 0
    temperature = get_temperature()
    IO.puts "Initial Temperature: #{temperature}"

    step(power)
  end

  def step(power) do
    temperature = get_temperature()
    IO.puts("TEMPERATURE: #{temperature}")
    if temperature < 51.667 - 1 do
      power = power_should_be_on(power)
    else
      power = power_should_be_off(power)
    end
    :timer.sleep(10000)
    step(power)
  end

  def power_should_be_on(power) do
    if power == 0 do
      IO.puts "POWERING ON"
      {output, 0} = System.cmd("python", ["utils/poweron.py"])
      1
    else
      IO.puts "KEEPING POWER ON"
      # The power is already on
      power
    end
  end

  def power_should_be_off(power) do
    if power == 1 do
      IO.puts "POWERING OFF"
      {output, 0} = System.cmd("python", ["utils/poweroff.py"])
      0
    else
      IO.puts "KEEPING POWER OFF"
      # The power is already off
      power
    end
  end

  def get_temperature do
    {output, 0} = System.cmd("elixir", ["utils/temperature.ex"])
    {decimal, _} = Float.parse(String.strip(output))
    decimal / 1000
  end
end

Sousvide.cook()
