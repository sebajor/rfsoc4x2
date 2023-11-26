
#white leds
set_property IOSTANDARD LVCMOS18 [get_ports {w_led[*]}]
set_property SLEW SLOW [get_ports {w_led_o[*]}]
set_property DRIVE 8 [get_ports {w_led[*]}]
set_property PACKAGE_PIN AR11 [ get_ports {w_led[0]}]
set_property PACKAGE_PIN AW10 [ get_ports {w_led[1]}]
set_property PACKAGE_PIN AT11 [ get_ports {w_led[2]}]
set_property PACKAGE_PIN AU10 [ get_ports {w_led[3]}]
#red leds
set_property IOSTANDARD LVCMOS18 [get_ports {r_led[*]}]
set_property SLEW SLOW [get_ports {r_led_o[*]}]
set_property DRIVE 8 [get_ports {r_led[*]}]
set_property PACKAGE_PIN AM8 [ get_ports {r_led[0]}]
set_property PACKAGE_PIN AR12 [ get_ports {r_led[1]}]
#green leds
set_property IOSTANDARD LVCMOS18 [get_ports {g_led[*]}]
set_property SLEW SLOW [get_ports {g_led_o[*]}]
set_property DRIVE 8 [get_ports {g_led[*]}]
set_property PACKAGE_PIN AM7 [ get_ports {g_led[0]}]
set_property PACKAGE_PIN AP8 [ get_ports {g_led[1]}]
#blue leds
set_property IOSTANDARD LVCMOS18 [get_ports {b_led[*]}]
set_property SLEW SLOW [get_ports {b_led_o[*]}]
set_property DRIVE 8 [get_ports {b_led[*]}]
set_property PACKAGE_PIN AN8 [ get_ports {b_led[0]}]
set_property PACKAGE_PIN AT10 [ get_ports {b_led[1]}]

#push buttons
set_property IOSTANDARD LVCMOS18 [get_ports {push_button[*]}]
set_property PACKAGE_PIN AV12 [ get_ports {push_button[0]}]
set_property PACKAGE_PIN AV10 [ get_ports {push_button[1]}]
set_property PACKAGE_PIN AW9 [ get_ports {push_button[2]}]
set_property PACKAGE_PIN AT12 [ get_ports {push_button[3]}]
set_property PACKAGE_PIN AN12 [ get_ports {push_button[4]}]

#slide switch
set_property IOSTANDARD LVCMOS18 [get_ports {slide_switch[*]}]
set_property PACKAGE_PIN AN13 [ get_ports {slide_switch[0]}]
set_property PACKAGE_PIN AU12 [ get_ports {slide_switch[1]}]
set_property PACKAGE_PIN AW11 [ get_ports {slide_switch[2]}]
set_property PACKAGE_PIN AV11 [ get_ports {slide_switch[3]}]


#pmod
set_property IOSTANDARD LVCMOS18 [ get_ports {pmod0[*]}]
set_property PACKAGE_PIN AF16 [ get_ports {pmod0[0]}]
set_property PACKAGE_PIN AG17 [ get_ports {pmod0[1]}]
set_property PACKAGE_PIN AJ16 [ get_ports {pmod0[2]}]
set_property PACKAGE_PIN AK17 [ get_ports {pmod0[3]}]
set_property PACKAGE_PIN AF15 [ get_ports {pmod0[4]}]
set_property PACKAGE_PIN AF17 [ get_ports {pmod0[5]}]
set_property PACKAGE_PIN AH17 [ get_ports {pmod0[6]}]
set_property PACKAGE_PIN AK16 [ get_ports {pmod0[7]}]


set_property IOSTANDARD LVCMOS18 [ get_ports {pmod1[*]}]
set_property PACKAGE_PIN AW13 [ get_ports {pmod1[0]}]
set_property PACKAGE_PIN AR13 [ get_ports {pmod1[1]}]
set_property PACKAGE_PIN AU13 [ get_ports {pmod1[2]}]
set_property PACKAGE_PIN AV13 [ get_ports {pmod1[3]}]
set_property PACKAGE_PIN AU15 [ get_ports {pmod1[4]}]
set_property PACKAGE_PIN AP14 [ get_ports {pmod1[5]}]
set_property PACKAGE_PIN AT15 [ get_ports {pmod1[6]}]
set_property PACKAGE_PIN AU14 [ get_ports {pmod1[7]}]


set_property IOSTANDARD LVCMOS18 [ get_ports {pmod01[*]}]
set_property PACKAGE_PIN AW16 [ get_ports {pmod01[0]}]
set_property PACKAGE_PIN AW15 [ get_ports {pmod01[1]}]
set_property PACKAGE_PIN AW14 [ get_ports {pmod01[2]}]
set_property PACKAGE_PIN AR16 [ get_ports {pmod01[3]}]
set_property PACKAGE_PIN AV16 [ get_ports {pmod01[4]}]
set_property PACKAGE_PIN AT16 [ get_ports {pmod01[5]}]


#syzygy
set_property PACKAGE_PIN AU2 [ get_ports "SYZYGY_D0_P" ]
set_property PACKAGE_PIN AU1 [ get_ports "SYZYGY_D0_N" ]
set_property PACKAGE_PIN A7 [ get_ports "SYZYGY_D1_P" ]
set_property PACKAGE_PIN A6 [ get_ports "SYZYGY_D1_N" ]
set_property PACKAGE_PIN AV3 [ get_ports "SYZYGY_D2_P" ]
set_property PACKAGE_PIN AV2 [ get_ports "SYZYGY_D2_N" ]
set_property PACKAGE_PIN C8 [ get_ports "SYZYGY_D3_P" ]
set_property PACKAGE_PIN C7 [ get_ports "SYZYGY_D3_N" ]
set_property PACKAGE_PIN AW4 [ get_ports "SYZYGY_D4_P" ]
set_property PACKAGE_PIN AW3 [ get_ports "SYZYGY_D4_N" ]
set_property PACKAGE_PIN E9 [ get_ports "SYZYGY_D5_P" ]
set_property PACKAGE_PIN E8 [ get_ports "SYZYGY_D5_N" ]
set_property PACKAGE_PIN AT7 [ get_ports "SYZYGY_D6_P" ]
set_property PACKAGE_PIN AT6 [ get_ports "SYZYGY_D6_N" ]
set_property PACKAGE_PIN F6 [ get_ports "SYZYGY_D7_P" ]
set_property PACKAGE_PIN E6 [ get_ports "SYZYGY_D7_N" ]

set_property PACKAGE_PIN B8 [ get_ports "SYZYGY_S16" ]
set_property PACKAGE_PIN D6 [ get_ports "SYZYGY_S18" ]
set_property PACKAGE_PIN C6 [ get_ports "SYZYGY_S20" ]
set_property PACKAGE_PIN B5 [ get_ports "SYZYGY_S22" ]
set_property PACKAGE_PIN A5 [ get_ports "SYZYGY_S24" ]
set_property PACKAGE_PIN C5 [ get_ports "SYZYGY_S26" ]

set_property PACKAGE_PIN AR6 [ get_ports "SYZYGY_S17" ]
set_property PACKAGE_PIN AR7 [ get_ports "SYZYGY_S19" ]
set_property PACKAGE_PIN AU7 [ get_ports "SYZYGY_S21" ]
set_property PACKAGE_PIN AV7 [ get_ports "SYZYGY_S23" ]
set_property PACKAGE_PIN AU8 [ get_ports "SYZYGY_S25" ]
set_property PACKAGE_PIN AV8 [ get_ports "SYZYGY_S27" ]

set_property PACKAGE_PIN AV6 [ get_ports "SYZYGY_P2C_CLK_P" ]
set_property PACKAGE_PIN B10 [ get_ports "SYZYGY_C2P_CLK_P" ]

## THE IO STANDARD IS DETERMINED BY THE SETTING OF VCCPSYZYGY
## SO MODIFY THE LINES BELOW TO REFLECT THE ACTUAL IO STANDARD
set_property IOSTANDARD LVCMOS18 [ get_ports "SYZYGY_S*"]
set_property IOSTANDARD LVCMOS18 [ get_ports "SYZYGY_D*"]
set_property IOSTANDARD LVCMOS18 [ get_ports "SYZYGY_P2C_CLK_P"]
set_property IOSTANDARD LVCMOS18 [ get_ports "SYZYGY_C2P_CLK_P"]


#QSFP
set_property PACKAGE_PIN AL22 [ get_ports "QSFP_MODPRSL" ]
set_property PACKAGE_PIN AM22 [ get_ports "QSFP_INTL" ]
set_property PACKAGE_PIN AL21 [ get_ports "QSFP_RESETL" ]
set_property PACKAGE_PIN AN22 [ get_ports "QSFP_LPMODE" ]
set_property PACKAGE_PIN AK22 [ get_ports "QSFP_MODSEL" ]
set_property IOSTANDARD LVCMOS18 [ get_ports "QSFP*"]



## 1PPS INTERFACE

set_property PACKAGE_PIN AK13 [ get_ports "IRIG_ADC_SDO" ]
set_property PACKAGE_PIN AH12 [ get_ports "IRIG_ADC_SCLK" ]
set_property PACKAGE_PIN AH13 [ get_ports "IRIG_TRIG_OUT" ]
set_property PACKAGE_PIN AJ13 [ get_ports "IRIG_COMP_OUT" ]
set_property PACKAGE_PIN AG14 [ get_ports "IRIG_ADC_CS_N" ]
set_property IOSTANDARD LVCMOS18 [ get_ports "IRIG*"]

##set the not used
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

