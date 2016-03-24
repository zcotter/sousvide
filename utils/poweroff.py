import time
import RPi.GPIO as io
io.setmode(io.BCM)

power_pin = 23

io.setup(power_pin, io.OUT)
io.output(power_pin, False)
print("POWER OFF")
# Waiting 5 seconds to make it harder to turn on and off too fast
time.sleep(5)
exit(0)
