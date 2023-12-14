#ADC timing constrain
##bit clock
create_clock -period 2.000 -name adc_bit_clk -waveform {0.000, 1.000} [get_ports syzygy_p2c_clk_p]

##input data
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -min -add_delay .35 [get_ports {syzygy_d0_[*]}];    #out1a_p,out1a_n
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -max -add_delay .65 [get_ports {syzygy_d0_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -min -add_delay .35 [get_ports {syzygy_d0_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -max -add_delay .65 [get_ports {syzygy_d0_[*]}];    #

set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -min -add_delay .35 [get_ports {syzygy_d2_[*]}];    #out1b_p,out1b_n
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -max -add_delay .65 [get_ports {syzygy_d2_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -min -add_delay .35 [get_ports {syzygy_d2_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -max -add_delay .65 [get_ports {syzygy_d2_[*]}];    #

set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -min -add_delay .35 [get_ports {syzygy_d3_[*]}];    #out2a_p,out2a_n
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -max -add_delay .65 [get_ports {syzygy_d3_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -min -add_delay .35 [get_ports {syzygy_d3_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -max -add_delay .65 [get_ports {syzygy_d3_[*]}];    #

set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -min -add_delay .35 [get_ports {syzygy_d5_[*]}];    #out1b_p,out1b_n
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -max -add_delay .65 [get_ports {syzygy_d5_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -min -add_delay .35 [get_ports {syzygy_d5_[*]}];    #
set_input_delay -clock [get_clocks adc_bit_clk] -max -add_delay .65 [get_ports {syzygy_d5_[*]}];    #

#frame clock
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -min -add_delay .350 [get_ports {syzygy_d1_p}]
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -max -add_delay .650 [get_ports {syzygy_d1_p}]
set_input_delay -clock [get_clocks adc_bit_clk] -min -add_delay .350 [get_ports {syzygy_d1_p}]
set_input_delay -clock [get_clocks adc_bit_clk] -max -add_delay .650 [get_ports {syzygy_d1_p}]
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -min -add_delay .350 [get_ports {syzygy_d1_n}]
set_input_delay -clock [get_clocks adc_bit_clk] -clock_fall -max -add_delay .650 [get_ports {syzygy_d1_n}]
set_input_delay -clock [get_clocks adc_bit_clk] -min -add_delay .350 [get_ports {syzygy_d1_n}]
set_input_delay -clock [get_clocks adc_bit_clk] -max -add_delay .650 [get_ports {syzygy_d1_n}]


###example constrains..
#create_clock -period 10.000 -name sys_clk [get_ports sys_clkp]
#set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks {mmcm0_clk0 okUH0}]
#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets idelay_adc_enc_clk/inst/clk_in1_clk_wiz_0]


# ADC timing constraints
#set_clock_groups -name decode_reset_group -asynchronous -group [get_clocks -of_objects [get_pins okHI/mmcm0/CLKOUT0]] -group [get_clocks -include_generated_clocks adc_bit_clk]
