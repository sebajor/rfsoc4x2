set cur_dir [pwd]
puts $cur_dir
set bd_dir $cur_dir/fpga.srcs/sources_1/bd/system
exec mkdir -p $cur_dir/rev

create_bd_design system
#instantiate ps
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:* mpsoc
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:* proc_sys_reset
#source the standard configuration
source ../ip/rfsoc4x2_mpsoc.tcl


#mpsoc clocks generation
#creating clock 0 
set_property -dict [list CONFIG.PSU__FPGA_PL0_ENABLE {1}] [get_bd_cells mpsoc]
set_property -dict [list CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100.000000}] [get_bd_cells mpsoc]
create_bd_net mpsoc_clk0
connect_bd_net -net mpsoc_clk0 [get_bd_pins mpsoc/pl_clk0]
create_bd_port -dir O -type clk mpsoc_clk_100
connect_bd_net -net mpsoc_clk0 [get_bd_ports mpsoc_clk_100]
set freq0_mhz [get_property CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ [get_bd_cells mpsoc]]
set freq0_hz [expr $freq0_mhz*1e6]
set_property -dict [list CONFIG.FREQ_HZ $freq0_hz] [get_bd_ports mpsoc_clk_100]


##reseting systemcreate_bd_net pl_resetn
connect_bd_net -net pl_resetn [get_bd_pins mpsoc/pl_resetn0]
create_bd_net axil_rst
create_bd_net axil_arst_n
connect_bd_net -net mpsoc_clk0 [get_bd_pins proc_sys_reset/slowest_sync_clk]
connect_bd_net -net pl_resetn [get_bd_pins proc_sys_reset/ext_reset_in]
connect_bd_net -net axil_rst [get_bd_pins proc_sys_reset/peripheral_reset]
connect_bd_net -net axil_arst_n [get_bd_pins proc_sys_reset/peripheral_aresetn]
create_bd_port -dir O -type rst axil_rst
create_bd_port -dir O -type rst axil_arst_n
connect_bd_net -net axil_rst [get_bd_ports axil_rst]
connect_bd_net -net axil_arst_n [get_bd_ports axil_arst_n]


##configuration for HPM0_FPD
set_property -dict [list CONFIG.PSU__USE__M_AXI_GP0 {1}] [get_bd_cells mpsoc] 
set_property -dict [list CONFIG.PSU__MAXIGP0__DATA_WIDTH {32}] [get_bd_cells mpsoc] 
##connect the clock
connect_bd_net -net mpsoc_clk0 [get_bd_pins mpsoc/maxihpm0_fpd_aclk]
##creating interconnect
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* hpm0_intercon 
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {3}] [get_bd_cells hpm0_intercon]
connect_bd_net -net axil_arst_n [get_bd_pins hpm0_intercon/ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm0_intercon/ACLK] 
connect_bd_net -net axil_arst_n [get_bd_pins hpm0_intercon/S00_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm0_intercon/S00_ACLK] 
connect_bd_intf_net [get_bd_intf_pins mpsoc/M_AXI_HPM0_FPD] -boundary_type upper [get_bd_intf_pins hpm0_intercon/S00_AXI]
make_bd_intf_pins_external  [get_bd_intf_pins hpm0_intercon/M00_AXI]
set_property name HPM0_FPD_M00_axil [get_bd_intf_ports M00_AXI_0]
set_property CONFIG.PROTOCOL AXI4LITE [get_bd_intf_ports /HPM0_FPD_M00_axil]
connect_bd_net -net axil_arst_n [get_bd_pins hpm0_intercon/M00_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm0_intercon/M00_ACLK] 
assign_bd_address [get_bd_addr_segs {HPM0_FPD_M00_axil/Reg }]
set_property range 32K [get_bd_addr_segs {mpsoc/Data/SEG_HPM0_FPD_M00_axil_Reg}]
set_property offset 0xA0040000 [get_bd_addr_segs {mpsoc/Data/SEG_HPM0_FPD_M00_axil_Reg}]
make_bd_intf_pins_external  [get_bd_intf_pins hpm0_intercon/M01_AXI]
set_property name HPM0_FPD_M01_axil [get_bd_intf_ports M01_AXI_0]
set_property CONFIG.PROTOCOL AXI4LITE [get_bd_intf_ports /HPM0_FPD_M01_axil]
connect_bd_net -net axil_arst_n [get_bd_pins hpm0_intercon/M01_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm0_intercon/M01_ACLK] 
assign_bd_address [get_bd_addr_segs {HPM0_FPD_M01_axil/Reg }]
set_property range 32K [get_bd_addr_segs {mpsoc/Data/SEG_HPM0_FPD_M01_axil_Reg}]
set_property offset 0xA0048000 [get_bd_addr_segs {mpsoc/Data/SEG_HPM0_FPD_M01_axil_Reg}]


##configuration for HPM1_FPD
set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {1}] [get_bd_cells mpsoc] 
set_property -dict [list CONFIG.PSU__MAXIGP1__DATA_WIDTH {64}] [get_bd_cells mpsoc] 
##connect the clock
connect_bd_net -net mpsoc_clk0 [get_bd_pins mpsoc/maxihpm1_fpd_aclk]
##creating interconnect
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* hpm1_intercon 
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2}] [get_bd_cells hpm1_intercon]
connect_bd_net -net axil_arst_n [get_bd_pins hpm1_intercon/ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm1_intercon/ACLK] 
connect_bd_net -net axil_arst_n [get_bd_pins hpm1_intercon/S00_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm1_intercon/S00_ACLK] 
connect_bd_intf_net [get_bd_intf_pins mpsoc/M_AXI_HPM1_FPD] -boundary_type upper [get_bd_intf_pins hpm1_intercon/S00_AXI]
make_bd_intf_pins_external  [get_bd_intf_pins hpm1_intercon/M00_AXI]
set_property name HPM1_FPD_M00_axil [get_bd_intf_ports M00_AXI_0]
set_property CONFIG.PROTOCOL AXI4LITE [get_bd_intf_ports /HPM1_FPD_M00_axil]
connect_bd_net -net axil_arst_n [get_bd_pins hpm1_intercon/M00_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm1_intercon/M00_ACLK] 
assign_bd_address [get_bd_addr_segs {HPM1_FPD_M00_axil/Reg }]
set_property range 32K [get_bd_addr_segs {mpsoc/Data/SEG_HPM1_FPD_M00_axil_Reg}]
set_property offset 0xB0000000 [get_bd_addr_segs {mpsoc/Data/SEG_HPM1_FPD_M00_axil_Reg}]
make_bd_intf_pins_external  [get_bd_intf_pins hpm1_intercon/M01_AXI]
set_property name HPM1_FPD_M01_axil [get_bd_intf_ports M01_AXI_0]
set_property CONFIG.PROTOCOL AXI4LITE [get_bd_intf_ports /HPM1_FPD_M01_axil]
connect_bd_net -net axil_arst_n [get_bd_pins hpm1_intercon/M01_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm1_intercon/M01_ACLK] 
assign_bd_address [get_bd_addr_segs {HPM1_FPD_M01_axil/Reg }]
set_property range 32K [get_bd_addr_segs {mpsoc/Data/SEG_HPM1_FPD_M01_axil_Reg}]
set_property offset 0xB0008000 [get_bd_addr_segs {mpsoc/Data/SEG_HPM1_FPD_M01_axil_Reg}]


##configuration for HPM0_LPD
set_property -dict [list CONFIG.PSU__USE__M_AXI_GP2 {0}] [get_bd_cells mpsoc] 


###RFDC part
create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:* rfdc
connect_bd_net -net axil_arst_n [get_bd_pins hpm0_intercon/M02_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm0_intercon/M02_ACLK] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins rfdc/s_axi_aclk]
connect_bd_net -net axil_arst_n [get_bd_pins rfdc/s_axi_aresetn] 
connect_bd_intf_net [get_bd_intf_pins hpm0_intercon/M02_AXI] -boundary_type upper [get_bd_intf_pins rfdc/s_axi]
assign_bd_address [get_bd_addr_segs {rfdc/s_axi/Reg }]
set_property range 256K [get_bd_addr_segs {mpsoc/Data/SEG_rfdc_Reg}]
set_property offset 0xA0000000 [get_bd_addr_segs {mpsoc/Data/SEG_rfdc_Reg}]

##configure tile 224
set_property CONFIG.ADC224_En {true} [get_bd_cells rfdc] 
set_property CONFIG.ADC0_Enable {1} [get_bd_cells rfdc] 
##configure adc0 from tile 224
set_property CONFIG.ADC_Slice00_Enable {true} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Type00 {0} [get_bd_cells rfdc]
set_property CONFIG.ADC_Decimation_Mode00 {1} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Width00 {8} [get_bd_cells rfdc]
set_property CONFIG.ADC_CalOpt_Mode00 {1} [get_bd_cells rfdc]
##configure adc1 from tile 224
set_property CONFIG.ADC_Slice02_Enable {true} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Type02 {0} [get_bd_cells rfdc]
set_property CONFIG.ADC_Decimation_Mode02 {1} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Width02 {8} [get_bd_cells rfdc]
set_property CONFIG.ADC_CalOpt_Mode02 {1} [get_bd_cells rfdc]

##create rfdc adc clocks
create_bd_port -dir I -type clk -freq_hz 4915200000 tile224_clk_p
create_bd_port -dir I -type clk -freq_hz 4915200000 tile224_clk_n
connect_bd_net [get_bd_pins rfdc/adc0_clk_p] [get_bd_ports tile224_clk_p] 
connect_bd_net [get_bd_pins rfdc/adc0_clk_n] [get_bd_ports tile224_clk_n] 
create_bd_port -dir I -type clk -freq_hz 1228800000 tile224_axis_input_clk
connect_bd_net [get_bd_pins rfdc/m0_axis_aclk] [get_bd_ports tile224_axis_input_clk]
create_bd_port -dir O -type clk tile224_data_clk
connect_bd_net [get_bd_pins rfdc/clk_adc0] [get_bd_ports tile224_data_clk]
set_property CONFIG.ADC0_Sampling_Rate {1.310720} [get_bd_cells rfdc]
set_property CONFIG.ADC0_PLL_Enable {true} [get_bd_cells rfdc]
set_property CONFIG.ADC0_Refclk_Freq {491.520} [get_bd_cells rfdc]
set_property CONFIG.ADC0_Outclk_Freq {122.880} [get_bd_cells rfdc]
set_property CONFIG.ADC0_Fabric_Freq {122.880} [get_bd_cells rfdc]
set_property CONFIG.ADC0_Multi_Tile_Sync {false} [get_bd_cells rfdc]
set_property CONFIG.ADC0_Clock_Dist {1} [get_bd_cells rfdc]
set_property CONFIG.ADC0_Clock_Source {0} [get_bd_cells rfdc]

##create physical pins
create_bd_port -dir I vin0_01_n
create_bd_port -dir I vin0_01_p
connect_bd_net [get_bd_pins rfdc/vin0_01_n] [get_bd_ports vin0_01_n]
connect_bd_net [get_bd_pins rfdc/vin0_01_p] [get_bd_ports vin0_01_p]
create_bd_port -dir O -from 127 -to 0 tile224_0_tdata
create_bd_port -dir O tile224_0_tvalid
create_bd_port -dir I tile224_0_tready
connect_bd_net [get_bd_pins rfdc/m00_axis_tdata] [get_bd_ports tile224_0_tdata]
connect_bd_net [get_bd_pins rfdc/m00_axis_tvalid] [get_bd_ports tile224_0_tvalid]
connect_bd_net [get_bd_pins rfdc/m00_axis_tready] [get_bd_ports tile224_0_tready]
create_bd_port -dir I vin0_23_n
create_bd_port -dir I vin0_23_p
connect_bd_net [get_bd_pins rfdc/vin0_23_n] [get_bd_ports vin0_23_n]
connect_bd_net [get_bd_pins rfdc/vin0_23_p] [get_bd_ports vin0_23_p]
create_bd_port -dir O -from 127 -to 0 tile224_1_tdata
create_bd_port -dir O tile224_1_tvalid
create_bd_port -dir I tile224_1_tready
connect_bd_net [get_bd_pins rfdc/m02_axis_tdata] [get_bd_ports tile224_1_tdata]
connect_bd_net [get_bd_pins rfdc/m02_axis_tvalid] [get_bd_ports tile224_1_tvalid]
connect_bd_net [get_bd_pins rfdc/m02_axis_tready] [get_bd_ports tile224_1_tready]

##configure tile 225
set_property CONFIG.ADC225_En {false} [get_bd_cells rfdc] 
set_property CONFIG.ADC1_Enable {0} [get_bd_cells rfdc] 

##configure tile 226
set_property CONFIG.ADC226_En {true} [get_bd_cells rfdc] 
set_property CONFIG.ADC2_Enable {1} [get_bd_cells rfdc] 
##configure adc0 from tile 226
set_property CONFIG.ADC_Slice20_Enable {true} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Type20 {0} [get_bd_cells rfdc]
set_property CONFIG.ADC_Decimation_Mode20 {1} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Width20 {8} [get_bd_cells rfdc]
set_property CONFIG.ADC_CalOpt_Mode20 {1} [get_bd_cells rfdc]
##configure adc1 from tile 226
set_property CONFIG.ADC_Slice22_Enable {true} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Type22 {0} [get_bd_cells rfdc]
set_property CONFIG.ADC_Decimation_Mode22 {1} [get_bd_cells rfdc]
set_property CONFIG.ADC_Data_Width22 {8} [get_bd_cells rfdc]
set_property CONFIG.ADC_CalOpt_Mode22 {1} [get_bd_cells rfdc]

##create rfdc adc clocks
create_bd_port -dir I -type clk -freq_hz 4915200000 tile226_clk_p
create_bd_port -dir I -type clk -freq_hz 4915200000 tile226_clk_n
connect_bd_net [get_bd_pins rfdc/adc2_clk_p] [get_bd_ports tile226_clk_p] 
connect_bd_net [get_bd_pins rfdc/adc2_clk_n] [get_bd_ports tile226_clk_n] 
create_bd_port -dir I -type clk -freq_hz 2457600000 tile226_axis_input_clk
connect_bd_net [get_bd_pins rfdc/m2_axis_aclk] [get_bd_ports tile226_axis_input_clk]
create_bd_port -dir O -type clk tile226_data_clk
connect_bd_net [get_bd_pins rfdc/clk_adc2] [get_bd_ports tile226_data_clk]
set_property CONFIG.ADC2_Sampling_Rate {3.932160} [get_bd_cells rfdc]
set_property CONFIG.ADC2_PLL_Enable {true} [get_bd_cells rfdc]
set_property CONFIG.ADC2_Refclk_Freq {491.520} [get_bd_cells rfdc]
set_property CONFIG.ADC2_Outclk_Freq {245.760} [get_bd_cells rfdc]
set_property CONFIG.ADC2_Fabric_Freq {245.760} [get_bd_cells rfdc]
set_property CONFIG.ADC2_Multi_Tile_Sync {false} [get_bd_cells rfdc]
set_property CONFIG.ADC2_Clock_Dist {1} [get_bd_cells rfdc]
set_property CONFIG.ADC2_Clock_Source {2} [get_bd_cells rfdc]

##create physical pins
create_bd_port -dir I vin2_01_n
create_bd_port -dir I vin2_01_p
connect_bd_net [get_bd_pins rfdc/vin2_01_n] [get_bd_ports vin2_01_n]
connect_bd_net [get_bd_pins rfdc/vin2_01_p] [get_bd_ports vin2_01_p]
create_bd_port -dir O -from 127 -to 0 tile226_0_tdata
create_bd_port -dir O tile226_0_tvalid
create_bd_port -dir I tile226_0_tready
connect_bd_net [get_bd_pins rfdc/m20_axis_tdata] [get_bd_ports tile226_0_tdata]
connect_bd_net [get_bd_pins rfdc/m20_axis_tvalid] [get_bd_ports tile226_0_tvalid]
connect_bd_net [get_bd_pins rfdc/m20_axis_tready] [get_bd_ports tile226_0_tready]
create_bd_port -dir I vin2_23_n
create_bd_port -dir I vin2_23_p
connect_bd_net [get_bd_pins rfdc/vin2_23_n] [get_bd_ports vin2_23_n]
connect_bd_net [get_bd_pins rfdc/vin2_23_p] [get_bd_ports vin2_23_p]
create_bd_port -dir O -from 127 -to 0 tile226_1_tdata
create_bd_port -dir O tile226_1_tvalid
create_bd_port -dir I tile226_1_tready
connect_bd_net [get_bd_pins rfdc/m22_axis_tdata] [get_bd_ports tile226_1_tdata]
connect_bd_net [get_bd_pins rfdc/m22_axis_tvalid] [get_bd_ports tile226_1_tvalid]
connect_bd_net [get_bd_pins rfdc/m22_axis_tready] [get_bd_ports tile226_1_tready]

##configure tile 227
set_property CONFIG.ADC227_En {false} [get_bd_cells rfdc] 
set_property CONFIG.ADC3_Enable {0} [get_bd_cells rfdc] 

##rfdc sysref clk
create_bd_port -dir I rfdc_sysref_p
create_bd_port -dir I rfdc_sysref_n
connect_bd_net [get_bd_pins rfdc/sysref_in_p] [get_bd_ports rfdc_sysref_p]
connect_bd_net [get_bd_pins rfdc/sysref_in_n] [get_bd_ports rfdc_sysref_n]

##set clock of the axi-lite interfaces
set_property CONFIG.ASSOCIATED_BUSIF {HPM0_FPD_M00_axil:HPM0_FPD_M01_axil:HPM1_FPD_M00_axil:HPM1_FPD_M01_axil} [get_bd_ports /mpsoc_clk_100]
make_wrapper -files [get_files $bd_dir/system.bd] -top
import_files -force -norecurse $bd_dir/hdl/system_wrapper.v
write_bd_tcl -force $cur_dir/rev/system.tcl
