package router_pkg;


//import uvm_pkg.sv
	import uvm_pkg::*;
//include uvm_macros.sv
	`include "uvm_macros.svh"

	`include "src_xtn.sv"
	`include "src_agt_config.sv"
	`include "dst_agt_config.sv"
	`include "router_env_config.sv"
	`include "src_driver.sv"
	`include "src_monitor.sv"
	`include "src_sequencer.sv"
	`include "src_agt.sv"
	`include "src_agt_top.sv"
	`include "src_seqs.sv"

	`include "dst_xtn.sv"
	`include "dst_driver.sv"
	`include "dst_monitor.sv"
	`include "dst_sequencer.sv"
	`include "dst_agt.sv"
	`include "dst_agt_top.sv"
	`include "dst_seqs.sv"


	`include "router_virtual_sequencer.sv"
	`include "router_virtual_seqs.sv"
	`include "router_scoreboard.sv"
	`include "router_env.sv"
	`include "router_test.sv"
endpackage
