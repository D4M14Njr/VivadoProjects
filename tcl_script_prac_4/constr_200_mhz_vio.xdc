create_clock -add -name clk_pin -period 5.00 -waveform {0 4} [get_ports { clk }]

set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk }]

set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN J17} [get_ports {an[0]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN J18} [get_ports {an[1]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T9} [get_ports {an[2]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN J14} [get_ports {an[3]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P14} [get_ports {an[4]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T14} [get_ports {an[5]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN K2} [get_ports {an[6]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U13} [get_ports {an[7]}]

set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T10} [get_ports {seg[0]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN R10} [get_ports {seg[1]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN K16} [get_ports {seg[2]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN K13} [get_ports {seg[3]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P15} [get_ports {seg[4]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T11} [get_ports {seg[5]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN L18} [get_ports {seg[6]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN H15} [get_ports {seg[7]}]