
#instantiate the rfdc in the block design
create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.5 usp_rf_data_converter_0
set rfdc [get_bd_cells -filter { NAME =~ *usp_rf_data_converter*}]

#create port to configure rfdc
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 RFDC
set_property -dict [list \
CONFIG.PROTOCOL [get_property CONFIG.PROTOCOL [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.ADDR_WIDTH [get_property CONFIG.ADDR_WIDTH [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.HAS_BURST [get_property CONFIG.HAS_BURST [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.HAS_LOCK [get_property CONFIG.HAS_LOCK [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.HAS_PROT [get_property CONFIG.HAS_PROT [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.HAS_CACHE [get_property CONFIG.HAS_CACHE [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.HAS_QOS [get_property CONFIG.HAS_QOS [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.HAS_REGION [get_property CONFIG.HAS_REGION [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.SUPPORTS_NARROW_BURST [get_property CONFIG.SUPPORTS_NARROW_BURST [get_bd_intf_pins $rfdc/s_axi]] \
CONFIG.MAX_BURST_LENGTH [get_property CONFIG.MAX_BURST_LENGTH [get_bd_intf_pins $rfdc/s_axi]] \
] [get_bd_intf_ports RFDC]

##create the interfaces for the axilite control of the rfdc
set_property -dict [list CONFIG.ADDR_WIDTH {40}] [get_bd_intf_ports RFDC]
#99990001 is created by the ps when set 100MHz
set_property -dict [list CONFIG.FREQ_HZ {99990001}] [get_bd_intf_ports RFDC]
connect_bd_intf_net [get_bd_intf_pins $rfdc/s_axi] [get_bd_intf_ports RFDC]
###this RFDC interface is not connected here!!!!
connect_bd_net [get_bd_pins $rfdc/s_axi_aclk] [get_bd_ports s_axi_aclk]
create_bd_port -dir I -type rst s_axi_aresetn
connect_bd_net [get_bd_pins $rfdc/s_axi_aresetn] [get_bd_ports s_axi_aresetn]
assign_bd_address -offset 0xA0000000 -range 256K [get_bd_addr_segs $rfdc/s_axi/Reg]

#configure the tiles
###note the 245 and 491 commes from the lmk and lmx chips
set_property -dict [list \
CONFIG.ADC224_En {false} \
CONFIG.ADC_Slice00_Enable {false} \
] [get_bd_cells $rfdc]
set_property -dict [list \
CONFIG.ADC224_En {true} \
CONFIG.ADC0_Enable {1} \
CONFIG.DAC228_En {false} \
CONFIG.DAC0_Enable {0} \
CONFIG.ADC225_En {true} \
CONFIG.ADC1_Enable {1} \
CONFIG.DAC229_En {false} \
CONFIG.DAC1_Enable {0} \
CONFIG.ADC226_En {true} \
CONFIG.ADC2_Enable {1} \
CONFIG.DAC230_En {false} \
CONFIG.DAC2_Enable {0} \
CONFIG.ADC227_En {true} \
CONFIG.ADC3_Enable {1} \
CONFIG.DAC231_En {false} \
CONFIG.DAC3_Enable {0} \
CONFIG.ADC0_Sampling_Rate {3.93216} \
CONFIG.ADC0_Refclk_Freq {491.520} \
CONFIG.ADC0_Outclk_Freq {245.760} \
CONFIG.ADC0_Fabric_Freq {245.760} \
CONFIG.ADC0_PLL_Enable {true} \
CONFIG.ADC0_Multi_Tile_Sync {false} \
CONFIG.ADC0_Clock_Dist {1} \
CONFIG.ADC0_Clock_Source {0} \
CONFIG.ADC_Slice00_Enable {true} \
CONFIG.ADC_Data_Type00 {0} \
CONFIG.ADC_Decimation_Mode00 {2} \
CONFIG.ADC_Data_Width00 {8} \
CONFIG.ADC_Mixer_Type00 {1} \
CONFIG.ADC_Mixer_Mode00 {2} \
CONFIG.ADC_NCO_Freq00 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq00 {3} \
CONFIG.ADC_Nyquist00 {0} \
CONFIG.ADC_CalOpt_Mode00 {1} \
CONFIG.ADC_Slice01_Enable {true} \
CONFIG.ADC_Data_Type01 {0} \
CONFIG.ADC_Decimation_Mode01 {2} \
CONFIG.ADC_Data_Width01 {8} \
CONFIG.ADC_Mixer_Type01 {1} \
CONFIG.ADC_Mixer_Mode01 {2} \
CONFIG.ADC_NCO_Freq01 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq01 {3} \
CONFIG.ADC_Nyquist01 {0} \
CONFIG.ADC_CalOpt_Mode01 {1} \
CONFIG.ADC_Slice02_Enable {true} \
CONFIG.ADC_Data_Type02 {0} \
CONFIG.ADC_Decimation_Mode02 {2} \
CONFIG.ADC_Data_Width02 {8} \
CONFIG.ADC_Mixer_Type02 {1} \
CONFIG.ADC_Mixer_Mode02 {2} \
CONFIG.ADC_NCO_Freq02 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq02 {3} \
CONFIG.ADC_Nyquist02 {0} \
CONFIG.ADC_CalOpt_Mode02 {1} \
CONFIG.ADC_Slice03_Enable {true} \
CONFIG.ADC_Data_Type03 {0} \
CONFIG.ADC_Decimation_Mode03 {2} \
CONFIG.ADC_Data_Width03 {8} \
CONFIG.ADC_Mixer_Type03 {1} \
CONFIG.ADC_Mixer_Mode03 {2} \
CONFIG.ADC_NCO_Freq03 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq03 {3} \
CONFIG.ADC_Nyquist03 {0} \
CONFIG.ADC_CalOpt_Mode03 {1} \
CONFIG.ADC1_Sampling_Rate {3.93216} \
CONFIG.ADC1_Refclk_Freq {491.520} \
CONFIG.ADC1_Outclk_Freq {245.760} \
CONFIG.ADC1_Fabric_Freq {245.760} \
CONFIG.ADC1_PLL_Enable {true} \
CONFIG.ADC1_Multi_Tile_Sync {false} \
CONFIG.ADC1_Clock_Dist {0} \
CONFIG.ADC1_Clock_Source {0} \
CONFIG.ADC_Slice10_Enable {true} \
CONFIG.ADC_Data_Type10 {0} \
CONFIG.ADC_Decimation_Mode10 {2} \
CONFIG.ADC_Data_Width10 {8} \
CONFIG.ADC_Mixer_Type10 {1} \
CONFIG.ADC_Mixer_Mode10 {2} \
CONFIG.ADC_NCO_Freq10 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq10 {3} \
CONFIG.ADC_Nyquist10 {0} \
CONFIG.ADC_CalOpt_Mode10 {1} \
CONFIG.ADC_Slice11_Enable {true} \
CONFIG.ADC_Data_Type11 {0} \
CONFIG.ADC_Decimation_Mode11 {2} \
CONFIG.ADC_Data_Width11 {8} \
CONFIG.ADC_Mixer_Type11 {1} \
CONFIG.ADC_Mixer_Mode11 {2} \
CONFIG.ADC_NCO_Freq11 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq11 {3} \
CONFIG.ADC_Nyquist11 {0} \
CONFIG.ADC_CalOpt_Mode11 {1} \
CONFIG.ADC_Slice12_Enable {true} \
CONFIG.ADC_Data_Type12 {0} \
CONFIG.ADC_Decimation_Mode12 {2} \
CONFIG.ADC_Data_Width12 {8} \
CONFIG.ADC_Mixer_Type12 {1} \
CONFIG.ADC_Mixer_Mode12 {2} \
CONFIG.ADC_NCO_Freq12 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq12 {3} \
CONFIG.ADC_Nyquist12 {0} \
CONFIG.ADC_CalOpt_Mode12 {1} \
CONFIG.ADC_Slice13_Enable {true} \
CONFIG.ADC_Data_Type13 {0} \
CONFIG.ADC_Decimation_Mode13 {2} \
CONFIG.ADC_Data_Width13 {8} \
CONFIG.ADC_Mixer_Type13 {1} \
CONFIG.ADC_Mixer_Mode13 {2} \
CONFIG.ADC_NCO_Freq13 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq13 {3} \
CONFIG.ADC_Nyquist13 {0} \
CONFIG.ADC_CalOpt_Mode13 {1} \
CONFIG.ADC2_Sampling_Rate {3.93216} \
CONFIG.ADC2_Refclk_Freq {491.520} \
CONFIG.ADC2_Outclk_Freq {245.760} \
CONFIG.ADC2_Fabric_Freq {245.760} \
CONFIG.ADC2_PLL_Enable {true} \
CONFIG.ADC2_Multi_Tile_Sync {false} \
CONFIG.ADC2_Clock_Dist {1} \
CONFIG.ADC2_Clock_Source {2} \
CONFIG.ADC_Slice20_Enable {true} \
CONFIG.ADC_Data_Type20 {0} \
CONFIG.ADC_Decimation_Mode20 {2} \
CONFIG.ADC_Data_Width20 {8} \
CONFIG.ADC_Mixer_Type20 {1} \
CONFIG.ADC_Mixer_Mode20 {2} \
CONFIG.ADC_NCO_Freq20 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq20 {3} \
CONFIG.ADC_Nyquist20 {0} \
CONFIG.ADC_CalOpt_Mode20 {1} \
CONFIG.ADC_Slice21_Enable {true} \
CONFIG.ADC_Data_Type21 {0} \
CONFIG.ADC_Decimation_Mode21 {2} \
CONFIG.ADC_Data_Width21 {8} \
CONFIG.ADC_Mixer_Type21 {1} \
CONFIG.ADC_Mixer_Mode21 {2} \
CONFIG.ADC_NCO_Freq21 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq21 {3} \
CONFIG.ADC_Nyquist21 {0} \
CONFIG.ADC_CalOpt_Mode21 {1} \
CONFIG.ADC_Slice22_Enable {true} \
CONFIG.ADC_Data_Type22 {0} \
CONFIG.ADC_Decimation_Mode22 {2} \
CONFIG.ADC_Data_Width22 {8} \
CONFIG.ADC_Mixer_Type22 {1} \
CONFIG.ADC_Mixer_Mode22 {2} \
CONFIG.ADC_NCO_Freq22 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq22 {3} \
CONFIG.ADC_Nyquist22 {0} \
CONFIG.ADC_CalOpt_Mode22 {1} \
CONFIG.ADC_Slice23_Enable {true} \
CONFIG.ADC_Data_Type23 {0} \
CONFIG.ADC_Decimation_Mode23 {2} \
CONFIG.ADC_Data_Width23 {8} \
CONFIG.ADC_Mixer_Type23 {1} \
CONFIG.ADC_Mixer_Mode23 {2} \
CONFIG.ADC_NCO_Freq23 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq23 {3} \
CONFIG.ADC_Nyquist23 {0} \
CONFIG.ADC_CalOpt_Mode23 {1} \
CONFIG.ADC3_Sampling_Rate {3.93216} \
CONFIG.ADC3_Refclk_Freq {491.520} \
CONFIG.ADC3_Outclk_Freq {245.760} \
CONFIG.ADC3_Fabric_Freq {245.760} \
CONFIG.ADC3_PLL_Enable {true} \
CONFIG.ADC3_Multi_Tile_Sync {false} \
CONFIG.ADC3_Clock_Dist {0} \
CONFIG.ADC3_Clock_Source {2} \
CONFIG.ADC_Slice30_Enable {true} \
CONFIG.ADC_Data_Type30 {0} \
CONFIG.ADC_Decimation_Mode30 {2} \
CONFIG.ADC_Data_Width30 {8} \
CONFIG.ADC_Mixer_Type30 {1} \
CONFIG.ADC_Mixer_Mode30 {2} \
CONFIG.ADC_NCO_Freq30 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq30 {3} \
CONFIG.ADC_Nyquist30 {0} \
CONFIG.ADC_CalOpt_Mode30 {1} \
CONFIG.ADC_Slice31_Enable {true} \
CONFIG.ADC_Data_Type31 {0} \
CONFIG.ADC_Decimation_Mode31 {2} \
CONFIG.ADC_Data_Width31 {8} \
CONFIG.ADC_Mixer_Type31 {1} \
CONFIG.ADC_Mixer_Mode31 {2} \
CONFIG.ADC_NCO_Freq31 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq31 {3} \
CONFIG.ADC_Nyquist31 {0} \
CONFIG.ADC_CalOpt_Mode31 {1} \
CONFIG.ADC_Slice32_Enable {true} \
CONFIG.ADC_Data_Type32 {0} \
CONFIG.ADC_Decimation_Mode32 {2} \
CONFIG.ADC_Data_Width32 {8} \
CONFIG.ADC_Mixer_Type32 {1} \
CONFIG.ADC_Mixer_Mode32 {2} \
CONFIG.ADC_NCO_Freq32 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq32 {3} \
CONFIG.ADC_Nyquist32 {0} \
CONFIG.ADC_CalOpt_Mode32 {1} \
CONFIG.ADC_Slice33_Enable {true} \
CONFIG.ADC_Data_Type33 {0} \
CONFIG.ADC_Decimation_Mode33 {2} \
CONFIG.ADC_Data_Width33 {8} \
CONFIG.ADC_Mixer_Type33 {1} \
CONFIG.ADC_Mixer_Mode33 {2} \
CONFIG.ADC_NCO_Freq33 {0.00000} \
CONFIG.ADC_Coarse_Mixer_Freq33 {3} \
CONFIG.ADC_Nyquist33 {0} \
CONFIG.ADC_CalOpt_Mode33 {1} \
] [get_bd_cells $rfdc]

##create the interface for the clocking 
create_bd_port -dir I -type clk -freq_hz 491520000 adc0_clk_n
connect_bd_net [get_bd_pins $rfdc/adc0_clk_n] [get_bd_ports adc0_clk_n]
create_bd_port -dir I -type clk -freq_hz 491520000 adc0_clk_p
connect_bd_net [get_bd_pins $rfdc/adc0_clk_p] [get_bd_ports adc0_clk_p]

##create adc clock interface (this one is generated by the rfdc and is synchronous with the adc data)
create_bd_port -dir O -type clk clk_adc0
connect_bd_net [get_bd_pins $rfdc/clk_adc0] [get_bd_ports clk_adc0]

create_bd_port -dir I -type clk -freq_hz 245760000 m0_axis_aclk
connect_bd_net [get_bd_pins $rfdc/m0_axis_aclk] [get_bd_ports m0_axis_aclk]

create_bd_port -dir I -type rst m0_axis_aresetn
connect_bd_net [get_bd_pins $rfdc/m0_axis_aresetn] [get_bd_ports m0_axis_aresetn]

##adc physical pins interface
create_bd_port -dir I vin0_01_n
connect_bd_net [get_bd_pins $rfdc/vin0_01_n] [get_bd_ports vin0_01_n]
create_bd_port -dir I vin0_01_p
connect_bd_net [get_bd_pins $rfdc/vin0_01_p] [get_bd_ports vin0_01_p]
##adc fabric axistream interface
create_bd_port -dir O -from 127 -to 0 m00_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m00_axis_tdata] [get_bd_ports m00_axis_tdata]
create_bd_port -dir O m00_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m00_axis_tvalid] [get_bd_ports m00_axis_tvalid]
create_bd_port -dir I m00_axis_tready
connect_bd_net [get_bd_pins $rfdc/m00_axis_tready] [get_bd_ports m00_axis_tready]

##now the same for the next adc
create_bd_port -dir I vin0_23_n
connect_bd_net [get_bd_pins $rfdc/vin0_23_n] [get_bd_ports vin0_23_n]
create_bd_port -dir I vin0_23_p
connect_bd_net [get_bd_pins $rfdc/vin0_23_p] [get_bd_ports vin0_23_p]
create_bd_port -dir O -from 127 -to 0 m02_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m02_axis_tdata] [get_bd_ports m02_axis_tdata]
create_bd_port -dir O m02_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m02_axis_tvalid] [get_bd_ports m02_axis_tvalid]
create_bd_port -dir I m02_axis_tready
connect_bd_net [get_bd_pins $rfdc/m02_axis_tready] [get_bd_ports m02_axis_tready


#this is the same but for the other adcs
create_bd_port -dir O -type clk clk_adc1
connect_bd_net [get_bd_pins $rfdc/clk_adc1] [get_bd_ports clk_adc1]

create_bd_port -dir I -type clk -freq_hz 245760000 m1_axis_aclk
connect_bd_net [get_bd_pins $rfdc/m1_axis_aclk] [get_bd_ports m1_axis_aclk]

create_bd_port -dir I -type rst m1_axis_aresetn
connect_bd_net [get_bd_pins $rfdc/m1_axis_aresetn] [get_bd_ports m1_axis_aresetn]
##adc physical pins interface
create_bd_port -dir I vin1_01_n
connect_bd_net [get_bd_pins $rfdc/vin1_01_n] [get_bd_ports vin1_01_n]
create_bd_port -dir I vin1_01_p
connect_bd_net [get_bd_pins $rfdc/vin1_01_p] [get_bd_ports vin1_01_p]
create_bd_port -dir O -from 127 -to 0 m10_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m10_axis_tdata] [get_bd_ports m10_axis_tdata]
create_bd_port -dir O m10_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m10_axis_tvalid] [get_bd_ports m10_axis_tvalid]
create_bd_port -dir I m10_axis_tready
connect_bd_net [get_bd_pins $rfdc/m10_axis_tready] [get_bd_ports m10_axis_tready]
create_bd_port -dir I vin1_23_n
connect_bd_net [get_bd_pins $rfdc/vin1_23_n] [get_bd_ports vin1_23_n]
create_bd_port -dir I vin1_23_p
connect_bd_net [get_bd_pins $rfdc/vin1_23_p] [get_bd_ports vin1_23_p]
create_bd_port -dir O -from 127 -to 0 m12_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m12_axis_tdata] [get_bd_ports m12_axis_tdata]
create_bd_port -dir O m12_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m12_axis_tvalid] [get_bd_ports m12_axis_tvalid]
create_bd_port -dir I m12_axis_tready
connect_bd_net [get_bd_pins $rfdc/m12_axis_tready] [get_bd_ports m12_axis_tready]

##clock for the other tile
create_bd_port -dir I -type clk -freq_hz 491520000 adc2_clk_n
connect_bd_net [get_bd_pins $rfdc/adc2_clk_n] [get_bd_ports adc2_clk_n]
create_bd_port -dir I -type clk -freq_hz 491520000 adc2_clk_p
connect_bd_net [get_bd_pins $rfdc/adc2_clk_p] [get_bd_ports adc2_clk_p]

##the same stuff than for the other one
create_bd_port -dir O -type clk clk_adc2
connect_bd_net [get_bd_pins $rfdc/clk_adc2] [get_bd_ports clk_adc2]
create_bd_port -dir I -type clk -freq_hz 245760000 m2_axis_aclk
connect_bd_net [get_bd_pins $rfdc/m2_axis_aclk] [get_bd_ports m2_axis_aclk]
create_bd_port -dir I -type rst m2_axis_aresetn
connect_bd_net [get_bd_pins $rfdc/m2_axis_aresetn] [get_bd_ports m2_axis_aresetn]
create_bd_port -dir I vin2_01_n
connect_bd_net [get_bd_pins $rfdc/vin2_01_n] [get_bd_ports vin2_01_n]
create_bd_port -dir I vin2_01_p
connect_bd_net [get_bd_pins $rfdc/vin2_01_p] [get_bd_ports vin2_01_p]
create_bd_port -dir O -from 127 -to 0 m20_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m20_axis_tdata] [get_bd_ports m20_axis_tdata]
create_bd_port -dir O m20_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m20_axis_tvalid] [get_bd_ports m20_axis_tvalid]
create_bd_port -dir I m20_axis_tready
connect_bd_net [get_bd_pins $rfdc/m20_axis_tready] [get_bd_ports m20_axis_tready]
create_bd_port -dir I vin2_23_n
connect_bd_net [get_bd_pins $rfdc/vin2_23_n] [get_bd_ports vin2_23_n]
create_bd_port -dir I vin2_23_p
connect_bd_net [get_bd_pins $rfdc/vin2_23_p] [get_bd_ports vin2_23_p]
create_bd_port -dir O -from 127 -to 0 m22_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m22_axis_tdata] [get_bd_ports m22_axis_tdata]
create_bd_port -dir O m22_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m22_axis_tvalid] [get_bd_ports m22_axis_tvalid]
create_bd_port -dir I m22_axis_tready
connect_bd_net [get_bd_pins $rfdc/m22_axis_tready] [get_bd_ports m22_axis_tready]
create_bd_port -dir O -type clk clk_adc3
connect_bd_net [get_bd_pins $rfdc/clk_adc3] [get_bd_ports clk_adc3]
create_bd_port -dir I -type clk -freq_hz 245760000 m3_axis_aclk
connect_bd_net [get_bd_pins $rfdc/m3_axis_aclk] [get_bd_ports m3_axis_aclk]
create_bd_port -dir I -type rst m3_axis_aresetn
connect_bd_net [get_bd_pins $rfdc/m3_axis_aresetn] [get_bd_ports m3_axis_aresetn]
create_bd_port -dir I vin3_01_n
connect_bd_net [get_bd_pins $rfdc/vin3_01_n] [get_bd_ports vin3_01_n]
create_bd_port -dir I vin3_01_p
connect_bd_net [get_bd_pins $rfdc/vin3_01_p] [get_bd_ports vin3_01_p]
create_bd_port -dir O -from 127 -to 0 m30_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m30_axis_tdata] [get_bd_ports m30_axis_tdata]
create_bd_port -dir O m30_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m30_axis_tvalid] [get_bd_ports m30_axis_tvalid]
create_bd_port -dir I m30_axis_tready
connect_bd_net [get_bd_pins $rfdc/m30_axis_tready] [get_bd_ports m30_axis_tready]
create_bd_port -dir I vin3_23_n
connect_bd_net [get_bd_pins $rfdc/vin3_23_n] [get_bd_ports vin3_23_n]
create_bd_port -dir I vin3_23_p
connect_bd_net [get_bd_pins $rfdc/vin3_23_p] [get_bd_ports vin3_23_p]
create_bd_port -dir O -from 127 -to 0 m32_axis_tdata
connect_bd_net [get_bd_pins $rfdc/m32_axis_tdata] [get_bd_ports m32_axis_tdata]
create_bd_port -dir O m32_axis_tvalid
connect_bd_net [get_bd_pins $rfdc/m32_axis_tvalid] [get_bd_ports m32_axis_tvalid]
create_bd_port -dir I m32_axis_tready
connect_bd_net [get_bd_pins $rfdc/m32_axis_tready] [get_bd_ports m32_axis_tready]

#create other control interfaces
create_bd_port -dir O -type intr irq
connect_bd_net [get_bd_pins $rfdc/irq] [get_bd_ports irq]
create_bd_port -dir I sysref_in_p
connect_bd_net [get_bd_pins $rfdc/sysref_in_p] [get_bd_ports sysref_in_p]
create_bd_port -dir I sysref_in_n
connect_bd_net [get_bd_pins $rfdc/sysref_in_n] [get_bd_ports sysref_in_n]



