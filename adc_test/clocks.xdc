
set_property IOSTANDARD LVDS [get_ports sys_clk_100m_p]
set_property PACKAGE_PIN AM15 [ get_ports sys_clk_100m_p]
create_clock -period 10 -name sys_clk_p -waveform {0.000 5.0} [get_ports {sys_clk100m_p}]

##for adc/dac subsystem 122.88 MHz
set_property IOSTANDARD LVDS [get_ports fpga_refclk_p]
set_property PACKAGE_PIN AN11 [ get_ports fpga_refclk_p]

set_property IOSTANDARD LVDS [get_ports fpga_refclk_n]
set_property PACKAGE_PIN AP11 [ get_ports fpga_refclk_n]

create_clock -period 8.138 -name fpga_refclk_p -waveform {0.000 4.069} [get_ports {fpga_refclk_p}]
##for adc/dac subsystem 7.68 MHz
set_property IOSTANDARD LVDS [get_ports sys_refclk_p]
set_property PACKAGE_PIN AP18 [ get_ports sys_refclk_p]

set_property IOSTANDARD LVDS [get_ports sys_refclk_n]
set_property PACKAGE_PIN AR18 [ get_ports sys_refclk_n]

create_clock -period 130.208 -name sys_refclk_p -waveform {0.000 65.104} [get_ports {sys_refclk_p}]

