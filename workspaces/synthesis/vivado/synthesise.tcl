#!/usr/bin/tclsh

#set root_path		/home/daniel-kho/Documents/projects/mil-vessel/hw/vhdl/blocksets/debug;
set vivado_synth_path	[pwd];
set log_path			$vivado_synth_path/logs;
set project_name		flight-controller;

# Load existing project.
open_project ./$project_name.xpr;

# Set project properties.
set_property board_part xilinx.com:zc702:part0:1.2	[current_project];
set_property target_language VHDL					[current_project];
set_property default_lib work						[current_project];

# Set file properties.
#set_property vhdl_version vhdl_2k					[get_filesets ila_0];
set_property vhdl_version vhdl_2008					[current_fileset];

# Synthesise design.
reset_run	synth_1;
launch_runs	synth_1	-jobs 2;
wait_on_run	synth_1;
puts "RTL design built.";

## Source design constraints.
#source $vivado_synth_path/src/constraints/timing.xdc;
#source $vivado_synth_path/src/constraints/layout.xdc;

#open_run			synth_1;
#connect_debug_port	dbg_hub/clk [get_nets bistClk];
#close_design;


# Build design.
reset_run	impl_1;
launch_runs	impl_1	-jobs 2;
wait_on_run	impl_1;
puts "Design placed and routed successfully.";

open_run	impl_1;

# Generate bitstream.
set_property BITSTREAM.GENERAL.COMPRESS TRUE [get_designs impl_1];
#write_bitstream -force $vivado_synth_path/workspaces/synthesis/vivado/$project_name/$project_name.runs/impl_1/$project_name.bit;
write_bitstream -force $vivado_synth_path/$project_name.runs/impl_1/$project_name.bit;
puts "Bitstream generated.";

# Dump reports.
report_utilization		-file $log_path/post-place-utilisation.rpt;
report_timing_summary	-file $log_path/post-place-timing.rpt;
report_timing_summary	-file $log_path/post-route-timing.rpt;
report_power			-file $log_path/post-route-power.rpt;
report_drc				-file $log_path/post-route-drc.rpt;

# Generate VHDL netlist.
write_vhdl -force $vivado_synth_path/../gls/$project_name.vhdl -mode funcsim;
puts "VHDL functional simulation netlist generated.";

close_design;

quit;
