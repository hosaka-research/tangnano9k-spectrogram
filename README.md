# tangnano9k-spectrogram

Realtime spectrogram on tangnano9k. All written in Verilog,
python is used to generate Verilog numerical table.

## BOM
* tang nano 9k[https://akizukidenshi.com/catalog/g/gM-17448/]
* 5inch LCD Display for Tang Nano [https://akizukidenshi.com/catalog/g/gM-14873/]
* Silicon mic module x2 (or x1) [https://akizukidenshi.com/catalog/g/gM-05577/]
* Breadboard [https://akizukidenshi.com/catalog/g/gP-12366/]

## Source codes & schematics

* stereomic/stereomic.pdf Digital microphones connection to tang nano 9k
* src/TOP.v top layer combine below and PLL.
* src/cic_digital_mic_90M_3M_6k.v microphone clock generation, cic downsampling filter and DC-cut filter.
* src/VGAMod2.v display controller and DFT, synchronized each other.
* src/python/cordic.v cos/sin generator
* src/python/theta_rom.v numerical table of phase change on every sample.
