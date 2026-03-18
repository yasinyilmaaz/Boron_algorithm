## =====================================================================
## 1. SAAT SİNYALİ (CLOCK)
## Basys 3 ana saati (100MHz) W5 pinindedir.
## =====================================================================
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## =====================================================================
## 2. LED BAĞLANTILARI
## Top modülündeki led[2:0] portuna göredir.
## =====================================================================
# led[0] -> Şifreleme Bitti (fin_enc)
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
# led[1] -> Deşifre Bitti (fin_dec)
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
# led[2] -> Kalp Atışı (Heartbeat - Saat varsa sürekli yanıp söner)
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {led[2]}]

## =====================================================================
## 3. VOLTAJ VE KONFİGÜRASYON AYARLARI (Zorunludur)
## =====================================================================
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## =====================================================================
## 4. DEBUG HUB (ILA KAMERA PİLİ) BAĞLANTISI
## ILA'nın Vivado tarafından görünmesini sağlayan kritik bağlantı.
## =====================================================================
set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]