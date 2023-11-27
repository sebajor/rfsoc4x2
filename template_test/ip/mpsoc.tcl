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
set_property -dict [list CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {150.000000}] [get_bd_cells mpsoc]
create_bd_net mpsoc_clk0
connect_bd_net -net mpsoc_clk0 [get_bd_pins mpsoc/pl_clk0]
create_bd_port -dir O -type clk mpsoc_clk_150
connect_bd_net -net mpsoc_clk0 [get_bd_ports mpsoc_clk_150]
set_property -dict [list CONFIG.FREQ_HZ {150000000}] [get_bd_ports mpsoc_clk_150]
#creating clock 1 
set_property -dict [list CONFIG.PSU__FPGA_PL1_ENABLE {1}] [get_bd_cells mpsoc]
set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100.000000}] [get_bd_cells mpsoc]
create_bd_net mpsoc_clk1
connect_bd_net -net mpsoc_clk1 [get_bd_pins mpsoc/pl_clk1]
create_bd_port -dir O -type clk mpsoc_clk_100
connect_bd_net -net mpsoc_clk1 [get_bd_ports mpsoc_clk_100]
set_property -dict [list CONFIG.FREQ_HZ {100000000}] [get_bd_ports mpsoc_clk_100]


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
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2}] [get_bd_cells hpm0_intercon]
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
set_property offset 0xA0000000 [get_bd_addr_segs {mpsoc/Data/SEG_HPM0_FPD_M00_axil_Reg}]
make_bd_intf_pins_external  [get_bd_intf_pins hpm0_intercon/M01_AXI]
set_property name HPM0_FPD_M01_axil [get_bd_intf_ports M01_AXI_0]
set_property CONFIG.PROTOCOL AXI4LITE [get_bd_intf_ports /HPM0_FPD_M01_axil]
connect_bd_net -net axil_arst_n [get_bd_pins hpm0_intercon/M01_ARESETN] 
connect_bd_net -net mpsoc_clk0 [get_bd_pins hpm0_intercon/M01_ACLK] 
assign_bd_address [get_bd_addr_segs {HPM0_FPD_M01_axil/Reg }]
set_property range 32K [get_bd_addr_segs {mpsoc/Data/SEG_HPM0_FPD_M01_axil_Reg}]
set_property offset 0xA0008000 [get_bd_addr_segs {mpsoc/Data/SEG_HPM0_FPD_M01_axil_Reg}]


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

##set clock of the axi-lite interfaces
set_property CONFIG.ASSOCIATED_BUSIF {HPM0_FPD_M00_axil:HPM0_FPD_M01_axil:HPM1_FPD_M00_axil:HPM1_FPD_M01_axil} [get_bd_ports /mpsoc_clk_150]
