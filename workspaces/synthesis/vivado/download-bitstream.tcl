#!/usr/bin/tclsh

set root_path		/home/daniel-kho/Documents/projects/mil-vessel;
set vhdl_src_path	$root_path/hw;
set log_path		$root_path/workspaces/synthesis/vivado/logs;
set project_name	flight-controller;

# Load existing project.
open_project ./$project_name.xpr;

# Set project properties.
set_property board_part xilinx.com:zc702:part0:1.2	[current_project];
set_property target_language	VHDL				[current_project];
set_property default_lib		work				[current_project];

start_gui;

open_run synth_1;

set_property C_CLK_INPUT_FREQ_HZ	300000000	[get_debug_cores dbg_hub];
set_property C_ENABLE_CLK_DIVIDER	false		[get_debug_cores dbg_hub];
set_property C_USER_SCAN_CHAIN		1			[get_debug_cores dbg_hub];

connect_debug_port dbg_hub/clk [get_nets bistClk];
#connect_debug_port dbg_hub/clk [get_nets bistClk_BUFG];
#connect_debug_port dbg_hub/clk [get_nets clkDiv];

# Download bitstream to FPGA.
close_hw;
open_hw;

#hw_server -e "set xsdb-user-bscan <C_USER_SCAN_CHAIN 2>";
#set xsdb-user-bscan <C_USER_SCAN_CHAIN 2>;
#set_property C_USER_SCAN_CHAIN 2 [get_debug_cores dbg_hub];

connect_hw_server;
open_hw_target				[lindex [get_hw_targets -of_objects [get_hw_servers localhost]] 0];

#set_property PROBES.FILE	{/home/daniel-kho/Documents/projects/$project_name/vivado-ila-issue/workspaces/$project_name/$project_name.runs/impl_1/debug_nets.ltx}	[lindex [get_hw_devices] 1];
set_property PROBES.FILE	{$root_path/workspaces/$project_name/$project_name.runs/impl_1/debug_nets.ltx}	[lindex [get_hw_devices] 1];

set_property PROGRAM.FILE	{/home/daniel-kho/Documents/projects/$project_name/vivado-ila-issue/workspaces/$project_name/$project_name.runs/impl_1/$project_name.bit}
							[lindex [get_hw_devices] 1];
#set_property PROGRAM.FILE	{$root_path/workspaces/$project_name/$project_name.runs/impl_1/$project_name.bit}	[lindex [get_hw_devices] 1];

close_design;

program_hw_devices			[lindex [get_hw_devices] 1];
current_hw_device			[lindex [get_hw_devices] 1];
refresh_hw_device			[lindex [get_hw_devices] 1];

display_hw_ila_data			[get_hw_ila_data hw_ila_data_1];

quit;
