puts "starting jasper device tree generation"
set jdts_dir /home/Workspace/simulink_models/Snapshots/RFSOC4x2/complex_samples/rfsoc_complex_snapshot/jdts/xil
file mkdir $jdts_dir
hsi::open_hw_design /home/Workspace/simulink_models/Snapshots/RFSOC4x2/complex_samples/rfsoc_complex_snapshot/myproj/myproj.runs/impl_1/top.xsa

# generate xilinx device tree products from xsa/block design
hsi::set_repo_path /home/Workspace/xlx_repository
set processor [hsi::get_cells * -filter {IP_TYPE==PROCESSOR}]
set processor [lindex $processor 0]
hsi::create_sw_design device-tree -os device_tree -proc $processor
hsi::set_property CONFIG.dt_overlay true [hsi::get_os]
hsi::generate_target -dir $jdts_dir

# generate property list for manual device tree node generation
set rfdc_dts_dir /home/Workspace/simulink_models/Snapshots/RFSOC4x2/complex_samples/rfsoc_complex_snapshot/jdts/rfdc
file mkdir $rfdc_dts_dir
set ofile "${rfdc_dts_dir}/rfdc.txt"
set rfdc [hsi::get_cells usp_rf_data_converter_0]
set prop_list [common::report_property -return_string $rfdc]
set clk_pins [hsi::get_pins -of_objects [hsi::get_cells -hier $rfdc] -filter {TYPE==clk&&DIRECTION==I}]
set out "${prop_list}\nDT.CLOCKS ${clk_pins}"
set fd_dts_outfile [open $ofile w+]
puts $fd_dts_outfile $out
close $fd_dts_outfile

hsi::close_hw_design [hsi::current_hw_design]