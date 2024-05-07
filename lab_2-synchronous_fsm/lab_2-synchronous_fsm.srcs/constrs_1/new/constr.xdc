create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports {clk}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {clk}];

set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {en_button}];
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {reset}];

set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {inp[0]}];
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {inp[1]}];
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {inp[2]}];
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {inp[3]}];
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {inp[4]}];
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {inp[5]}];
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {inp[6]}];
set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports {inp[7]}];
set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS33} [get_ports {inp[8]}];
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33} [get_ports {inp[9]}];
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {inp[10]}];
set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS33} [get_ports {inp[11]}];
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports {inp[12]}];
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {inp[13]}];
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports {inp[14]}];
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports {inp[15]}];

set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {an[0]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {an[1]}]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {an[2]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {an[3]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {an[4]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {an[5]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {an[6]}]
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {an[7]}]

set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {seg[0]}]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports {seg[1]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {seg[2]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {seg[3]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {seg[4]}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {seg[5]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {seg[6]}]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {seg[7]}]

set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {result_led[0]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {result_led[1]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {result_led[2]}]
