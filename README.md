# tangnano9k-spectrogram

Realtime spectrogram on tang nano 9k with 5" LCD Display.
Python code is used to generate Verilog numerical table.

## BOM
* tang nano 9k[https://akizukidenshi.com/catalog/g/gM-17448/]
* 5inch LCD Display for Tang Nano [https://akizukidenshi.com/catalog/g/gM-14873/]
* Silicon mic module x2 (or x1) [https://akizukidenshi.com/catalog/g/gM-05577/]
* Breadboard [https://akizukidenshi.com/catalog/g/gP-12366/]

## Source codes & schematics

* stereomic/stereomic.pdf Digital microphones connection to tang nano 9k
* src/TOP.v top layer and PLL(27MHz->90MHz).
* src/cic_digital_mic_90M_3M_6k.v microphone clock generation(90MHz->3MHz), cic downsampling filter(3MHz->6kHz) and DC-cut filter.
* src/VGAMod2.v DFT built-in display controller (Pixel clock=22.5Mhz)

