#!/usr/bin/tclsh

set root_path		/home/daniel-kho/Documents/projects/sandbox/vivado-ila-issue;
set vhdl_src_path	$root_path/hw;
set log_path		$root_path/workspaces/sandbox/logs;

# Load existing project.
open_project ./sandbox.xpr;

# Set project properties.
set_property board_part xilinx.com:zc702:part0:1.2	[current_project];
set_property target_language VHDL					[current_project];
set_property default_lib work						[current_project];

# Set file properties.
set_property vhdl_version vhdl_2k					[get_filesets ila_0];
set_property vhdl_version vhdl_2008					[current_fileset];

# Build libraries and macros.
generate_target all	[get_files	$root_path/workspaces/sandbox/sandbox.srcs/sources_1/ip/ila_0/ila_0.xci];
reset_run	ila_0_synth_1;
launch_run	ila_0_synth_1 -jobs 2;

generate_target all	[get_files	$root_path/workspaces/sandbox/sandbox.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci];
reset_run	clk_wiz_0_synth_1;
launch_run	clk_wiz_0_synth_1 -jobs 2;


wait_on_run	ila_0_synth_1;
puts "ILA macro built.";

wait_on_run	clk_wiz_0_synth_1;
puts "Clocking macro built.";

quit;
