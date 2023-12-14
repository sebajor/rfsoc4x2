puts "starting jasper device tree generation"
set jdts_dir /home/Workspace/test/test/jdts/xil
file mkdir $jdts_dir
hsi::open_hw_design /home/Workspace/test/test/myproj/myproj.runs/impl_1/top.xsa

# generate xilinx device tree products from xsa/block design
hsi::set_repo_path /home/Workspace/device-tree-xlnx
set processor [hsi::get_cells * -filter {IP_TYPE==PROCESSOR}]
set processor [lindex $processor 0]
hsi::create_sw_design device-tree -os device_tree -proc $processor
hsi::set_property CONFIG.dt_overlay true [hsi::get_os]
hsi::generate_target -dir $jdts_dir
hsi::close_hw_design [hsi::current_hw_design]