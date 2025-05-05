This config is for the sthlmkb CYOA ortho using the 5x12 configuration (nothing snapped off).
I didn't have a pin-compatible MCU, but had an Adafruit Itsy Bitsy based on the nrf52840 lying around.
That board has the same physical layout as a Pro Micro, but a different pinout (including VCC/GND conflicts).
I used a DIP socket, soldered to the CYOA with some bodge wires since the Itsy's A5 pin has a one-way level shifter and can't be used, as well as some GND/VCC rerouting.

If you want to use this for your CYOA with a pro micro & ZMK compatible controller (32 bit), you can find the vanilla pro micro GPIO layout commented out in the shield overlay file `boards/shields/sthlmkb_cyoa/sthlmkb_cyoa.overlay`.
Change over to that, check it for correctness and rebuild for your board.
You might also have to change active_high/low and pullup/pulldown config, I had to change it from the default boardsource5x12 this is based on.