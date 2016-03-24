{:ok, output} = File.read "/sys/bus/w1/devices/28-0000072e8a52/w1_slave"
# Expected output format:
# 18 01 4b 46 7f ff 08 10 b0 : crc=b0 YES
# 18 01 4b 46 7f ff 08 10 b0 t=17500

# Where:
#   t= Thousandths of Degrees Celsius
IO.puts List.last(String.split(String.strip(output), "t="))
