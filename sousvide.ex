defmodule Sousvide do
  @target_temperature 51.667
  @target_time 60 * 60 * 4.0 # 4 hours

  def cook do
    power = 0
    temperature = get_temperature()
    IO.puts "Initial Temperature: #{temperature}"

    step(power, temperature, [], 0)
  end

  def step(power, last_temperature, history, time_at_temp) do
    temperature = get_temperature()
    estimate_time_left(temperature, last_temperature, time_at_temp)
    IO.puts("TEMPERATURE: #{temperature}")
    power = if temperature < @target_temperature - 0.25 do
      power_should_be_on(power)
    else
      power_should_be_off(power)
    end
    :timer.sleep(10000)
    if temperature >= @target_temperature - 1 do
      time_at_temp = time_at_temp + 10
      IO.puts "TIME AT TEMP: #{time_at_temp}"
    end
    history = history ++ [temperature]
    write_logs(temperature)
    if time_at_temp < @target_time do
      step(power, temperature, history, time_at_temp)
    else
      IO.puts "DONE!!!"
    end
  end

  def write_logs(temperature) do
    {:ok, file} = File.open "logs/history.log", [:append]
    IO.binwrite file, inspect("#{temperature}\n")
  end

  def estimate_time_left(current_temperature, last_temperature, time_at_temp) do
    degrees_per_second = (current_temperature - last_temperature) / 10#s
    seconds_per_degree = if degrees_per_second == 0  do
      0
    else
      1 / degrees_per_second
    end
    degrees_to_go = @target_temperature - current_temperature
    seconds_left = seconds_per_degree * degrees_to_go
    minutes_left = Float.ceil(seconds_left / 60)
    if current_temperature >= @target_temperature - 1 do
      IO.puts "COOK TIME REMAINING #{@target_time - time_at_temp} MINUTES"
    else
      IO.puts "#{minutes_left} MINUTES TO TARGET TEMP"
    end

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
