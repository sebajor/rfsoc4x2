set impl_dir "/home/Workspace/test/test/myproj/myproj.runs/impl_1"
set bin_file "/home/Workspace/test/test/myproj/myproj.runs/impl_1/top.bin"
set bit_file "/home/Workspace/test/test/myproj/myproj.runs/impl_1/top.bit"
set hex_file "/home/Workspace/test/test/myproj/myproj.runs/impl_1/top.hex"
set mcs_file "/home/Workspace/test/test/myproj/myproj.runs/impl_1/top.mcs"
set prm_file "/home/Workspace/test/test/myproj/myproj.runs/impl_1/top.prm"
set xsa_file "/home/Workspace/test/test/myproj/myproj.runs/impl_1/top.xsa"
set jbd_name "rfsoc4x2_bd"

proc check_timing {run} {
  if { [get_property STATS.WNS [get_runs $run] ] < 0 } {
    send_msg_id "CASPER-1" {CRITICAL WARNING} "ERROR: Found timing violations => Worst Negative Slack: [get_property STATS.WNS [get_runs $run]] ns"
  } else {
    puts "No timing violations => Worst Negative Slack: [get_property STATS.WNS [get_runs $run]] ns"
  }

  if { [get_property STATS.TNS [get_runs $run] ] < 0 } {
    send_msg_id "CASPER-1" {CRITICAL WARNING} "ERROR: Found timing violations => Total Negative Slack: [get_property STATS.TNS [get_runs $run]] ns"
  }

  if { [get_property STATS.WHS [get_runs $run] ] < 0 } {
    send_msg_id "CASPER-1" {CRITICAL WARNING} "ERROR: Found timing violations => Worst Hold Slack: [get_property STATS.WHS [get_runs $run]] ns"
  } else {
    puts "No timing violations => Worst Hold Slack: [get_property STATS.WHS [get_runs $run]] ns"
  }

  if { [get_property STATS.THS [get_runs $run] ] < 0 } {
    send_msg_id "CASPER-1" {CRITICAL WARNING} "ERROR: Found timing violations => Total Hold Slack: [get_property STATS.THS [get_runs $run]] ns"
  }
}


proc check_zero_critical {count mess} {
  if {$count > 0} {
    puts "************************************************"
    send_msg_id "CASPER-2" {CRITICAL WARNING} "$mess critical warning count: $count"
    puts "************************************************"
  }
}


proc puts_red {s} {
  puts -nonewline "\[1;31m"; #RED
  puts $s
  puts -nonewline "\[0m";# Reset
}

puts "Starting tcl script"
cd /home/Workspace/test/test
create_project -f myproj myproj -part xczu48dr-ffvg1517-2-e
create_bd_design $jbd_name
current_bd_design $jbd_name
set_property target_language VHDL [current_project]
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:* mpsoc
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:* proc_sys_reset
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:* axi_proto_conv
source /home/Workspace/mlib_devel/jasper_library/hdl_sources/zynq/rfsoc4x2_mpsoc.tcl
create_bd_net pl_sys_clk
connect_bd_net -net pl_sys_clk [get_bd_pins mpsoc/pl_clk0]
create_bd_net pl_resetn
connect_bd_net -net pl_resetn [get_bd_pins mpsoc/pl_resetn0]
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
import_files -force /home/Workspace/test/test/top.v
import_files -force /home/Workspace/mlib_devel/jasper_library/hdl_sources/wb_register_simulink2ppc
import_files -force /home/Workspace/mlib_devel/jasper_library/hdl_sources/wb_register_ppc2simulink
import_files -force /home/Workspace/mlib_devel/jasper_library/hdl_sources/infrastructure/zcu216_clk_infrastructure.sv
import_files -force /home/Workspace/mlib_devel/jasper_library/hdl_sources/utils/cdc_synchroniser.vhd
import_files -force /home/Workspace/mlib_devel/jasper_library/hdl_sources/sys_block
import_files -force /home/Workspace/mlib_devel/jasper_library/hdl_sources/axi4_lite/axi4lite_slave_logic.vhd
import_files -force /home/Workspace/mlib_devel/jasper_library/hdl_sources/axi4_lite/axi4lite_pkg.vhd
import_files -force /home/Workspace/test/test/axi4lite_ic_wrapper.vhdl
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_axi4lite_top_ic.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_axi4lite_top_mmap_pkg.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_sys_muxdemux.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_sw_reg.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_sys.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_sw_reg_pkg.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_axi4lite_top_ic_pkg.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_sys_pkg.vhd
import_files -force /home/Workspace/test/test/xml2vhdl_hdl_output/axi4lite_sw_reg_muxdemux.vhd
set repos [get_property ip_repo_paths [current_project]]
set_property ip_repo_paths "$repos /home/Workspace/test/test/sysgen" [current_project]
update_ip_catalog
create_ip -name test -vendor User_Company -library SysGen -version 1.0 -module_name test_ip
import_files -force -fileset constrs_1 /home/Workspace/test/test/user_const.xdc
set_property top top [current_fileset]
update_compile_order -fileset sources_1
if {[llength [glob -nocomplain [get_property directory [current_project]]/myproj.srcs/sources_1/imports/*.coe]] > 0} {
file copy -force {*}[glob [get_property directory [current_project]]/myproj.srcs/sources_1/imports/*.coe] [get_property directory [current_project]]/myproj.srcs/sources_1/ip/
}
upgrade_ip -quiet [get_ips *]
import_files {/home/Workspace/mlib_devel/jasper_library/hdl_sources/axi4_lite/axi4lite_slave_logic.vhd /home/Workspace/mlib_devel/jasper_library/hdl_sources/axi4_lite/axi4lite_pkg.vhd}
update_compile_order -fileset sources_1
save_bd_design
validate_bd_design
generate_target all [get_files [get_property directory [current_project]]/myproj.srcs/sources_1/bd/rfsoc4x2_bd/rfsoc4x2_bd.bd]
make_wrapper -files [get_files [get_property directory [current_project]]/myproj.srcs/sources_1/bd/rfsoc4x2_bd/rfsoc4x2_bd.bd] -top
add_files -norecurse [get_property directory [current_project]]/myproj.srcs/sources_1/bd/rfsoc4x2_bd/hdl/rfsoc4x2_bd_wrapper.vhd
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1
set synth_critical_count [get_msg_config -count -severity {CRITICAL WARNING}]
set_property STEPS.POST_PLACE_POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
launch_runs impl_1 -jobs 4
wait_on_run impl_1
open_run impl_1
set impl_critical_count [get_msg_config -count -severity {CRITICAL WARNING}]
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
cd [get_property DIRECTORY [current_project]]
write_hw_platform -fixed -include_bit -force -file $xsa_file
check_timing impl_1
check_zero_critical $impl_critical_count implementation
check_zero_critical $synth_critical_count synthesis
