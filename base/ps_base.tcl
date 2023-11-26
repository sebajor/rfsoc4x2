###at the end of this code you have a pl_sys_clk signal at 100MHz, a HPM0 axi port connected to a axi protocol converter to have the interface M_AXI that is axilite. We also hace axil_rst and axil_rst_n interface on the design


create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:* mpsoc
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:* proc_sys_reset
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:* axi_proto_conv
#configure the mpsoc with default settings
source rfsoc4x2_mpsoc.tcl

##get clock from the ps (set at approx 100MHz)
create_bd_net pl_sys_clk
connect_bd_net -net pl_sys_clk [get_bd_pins mpsoc/pl_clk0]
create_bd_net pl_resetn
connect_bd_net -net pl_resetn [get_bd_pins mpsoc/pl_resetn0]
##configure the GP ports bitwidhts
set_property -dict [list \
CONFIG.PSU__USE__M_AXI_GP0 {1} \
CONFIG.PSU__MAXIGP0__DATA_WIDTH {32} \
CONFIG.PSU__USE__M_AXI_GP1 {0} \
CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
CONFIG.PSU__USE__M_AXI_GP2 {0} \
CONFIG.PSU__MAXIGP2__DATA_WIDTH {128} \
] [get_bd_cells mpsoc]

set freq_mhz [get_property CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ [get_bd_cells mpsoc]]
set ps_freq_hz [expr $freq_mhz*1e6]

connect_bd_net -net pl_sys_clk [get_bd_pins mpsoc/maxihpm0_fpd_aclk]
create_bd_port -dir O -type clk pl_sys_clk
connect_bd_net -net pl_sys_clk [get_bd_ports pl_sys_clk]
connect_bd_net -net pl_sys_clk [get_bd_pins proc_sys_reset/slowest_sync_clk]
create_bd_net axil_rst
create_bd_net axil_arst_n
connect_bd_net -net pl_resetn [get_bd_pins proc_sys_reset/ext_reset_in]
connect_bd_net -net axil_rst [get_bd_pins proc_sys_reset/peripheral_reset]
connect_bd_net -net axil_arst_n [get_bd_pins proc_sys_reset/peripheral_aresetn]
create_bd_port -dir O -type rst axil_rst
create_bd_port -dir O -type rst axil_arst_n
connect_bd_net -net axil_rst [get_bd_ports axil_rst]
connect_bd_net -net axil_arst_n [get_bd_ports axil_arst_n]
##convert the from axi4 to axilite
set_property -dict [list \
CONFIG.ARUSER_WIDTH {0} \
CONFIG.AWUSER_WIDTH {0} \
CONFIG.BUSER_WIDTH {0} \
CONFIG.DATA_WIDTH {32} \
CONFIG.ID_WIDTH {16} \
CONFIG.MI_PROTOCOL {AXI4LITE} \
CONFIG.READ_WRITE_MODE {READ_WRITE} \
CONFIG.RUSER_WIDTH {0} \
CONFIG.SI_PROTOCOL {AXI4} \
CONFIG.TRANSLATION_MODE {2} \
CONFIG.WUSER_WIDTH {0} \
] [get_bd_cells axi_proto_conv]
##connect poins
connect_bd_net -net pl_sys_clk [get_bd_pins axi_proto_conv/aclk]
connect_bd_net -net axil_arst_n [get_bd_pins axi_proto_conv/aresetn]
connect_bd_intf_net [get_bd_intf_pins mpsoc/M_AXI_HPM0_FPD] [get_bd_intf_pins axi_proto_conv/S_AXI]
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
set_property -dict [list \
CONFIG.PROTOCOL [get_property CONFIG.PROTOCOL [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.ADDR_WIDTH [get_property CONFIG.ADDR_WIDTH [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.DATA_WIDTH [get_property CONFIG.DATA_WIDTH [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.HAS_BURST [get_property CONFIG.HAS_BURST [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.HAS_LOCK [get_property CONFIG.HAS_LOCK [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.HAS_PROT [get_property CONFIG.HAS_PROT [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.HAS_CACHE [get_property CONFIG.HAS_CACHE [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.HAS_QOS [get_property CONFIG.HAS_QOS [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.HAS_REGION [get_property CONFIG.HAS_REGION [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.SUPPORTS_NARROW_BURST [get_property CONFIG.SUPPORTS_NARROW_BURST [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.MAX_BURST_LENGTH [get_property CONFIG.MAX_BURST_LENGTH [get_bd_intf_pins axi_proto_conv/M_AXI]] \
CONFIG.FREQ_HZ $ps_freq_hz \
] [get_bd_intf_ports M_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_proto_conv/M_AXI] [get_bd_intf_pins M_AXI]
assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mpsoc/Data] [get_bd_addr_segs M_AXI/Reg] -force


