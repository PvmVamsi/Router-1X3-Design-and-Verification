//Scoreboard
class router_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(router_scoreboard)
	 //tlm analysis fifo ports	
	uvm_tlm_analysis_fifo#(src_xtn) src_fifoh[];
	uvm_tlm_analysis_fifo#(dst_xtn) dst_fifoh[];
	
	//config
	router_env_config env_cfg;

	src_xtn xtn1;
	dst_xtn xtn2;

	covergroup src;
		address : coverpoint xtn1.header[1:0]{bins add_bin[] = {[0:2]};illegal_bins add = {3};}
		payload_size: coverpoint xtn1.header[7:2]{
				bins small_pkt = {[1: 20]};
				bins mid_pkt = {[21:40]}; 
				bins big_pkt = {[41:63]};}

	endgroup

	covergroup dst;
		address : coverpoint xtn2.header[1:0]{bins add_bin[] = {[0:2]};illegal_bins add = {3};}
		payload_size: coverpoint xtn2.header[7:2]{
				bins small_pkt = {[1: 20]};
				bins mid_pkt = {[21:40]}; 
				bins big_pkt = {[41:63]};}

	endgroup

//uvm methods
extern function new(string name = "router_scoreboard",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task check_data(src_xtn xtn1,dst_xtn xtn2);
endclass

function router_scoreboard::new(string name ="router_scoreboard",uvm_component parent = null);
	super.new(name,parent);
	src = new;
	dst = new;	
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config) :: get(this,"","router_env_config",env_cfg))
			`uvm_fatal(get_type_name(),"Cant get the env config from sb");
	src_fifoh = new[env_cfg.no_of_src];
	foreach(src_fifoh[i])
		src_fifoh[i] = new($sformatf("src_fifoh[%0d]",i),this);

	dst_fifoh = new[env_cfg.no_of_dst];
	foreach(dst_fifoh[i])
		dst_fifoh[i] = new($sformatf("dst_fifoh[%0d]",i),this);

endfunction

task router_scoreboard::run_phase(uvm_phase phase);
		fork 
			begin 
				forever 
					begin 
						src_fifoh[0].get(xtn1);
						$display("src pkt From scoreboard");
						xtn1.print(); 
						src.sample();  
					end
			end

			begin 
				forever
				begin
					fork 
						begin 
							dst_fifoh[0].get(xtn2); 
							dst.sample();
							 $display("dst[0] pkt From scoreboard");
							xtn2.print(); 

							check_data(xtn1,xtn2); 
						end
						
						begin 
							dst_fifoh[1].get(xtn2); 
							dst.sample(); 
							$display("dst[1] pkt From scoreboard");
							xtn2.print(); 


							check_data(xtn1,xtn2); 
						end
						begin 
							dst_fifoh[2].get(xtn2); 
							dst.sample(); 
							$display("dst[2] pkt From scoreboard");
							xtn2.print(); 
							check_data(xtn1,xtn2); 
						end
					join_any
					disable fork;
				end 
			end
		join 		
endtask
/*
task router_scoreboard::check_data(dst_xtn xtn2);
	//`uvm_info(get_type_name(),$sformatf("source_xtn %s dest_xtn %s",sxtn.sprint,dxtn.sprint),UVM_LOW) 
		if(xtn1.header == xtn2.header)	
			`uvm_info(get_full_name, "Header compared successfully", UVM_LOW)
		else
			`uvm_info(get_full_name, "Header mismatch", UVM_LOW)

		if(xtn1.payload == xtn2.payload)	
			`uvm_info(get_full_name, "Payload compared successfully", UVM_LOW)
		else
			`uvm_info(get_full_name, "Payload mismatch", UVM_LOW)

		if(xtn1.parity == xtn2.parity)	
			`uvm_info(get_full_name, "Parity compared successfully", UVM_LOW)
		else
			`uvm_info(get_full_name, "Parity mismatch", UVM_LOW)


	endtask 	*/

task router_scoreboard::check_data(src_xtn xtn1,dst_xtn xtn2);
	//`uvm_info(get_type_name(),$sformatf("source_xtn %s dest_xtn %s",sxtn.sprint,dxtn.sprint),UVM_LOW) 
		if(xtn1.header == xtn2.header)	
			`uvm_info(get_full_name, "Header compared successfully", UVM_LOW)
		else
			`uvm_info(get_full_name, "Header mismatch", UVM_LOW)

		if(xtn1.payload == xtn2.payload)	
			`uvm_info(get_full_name, "Payload compared successfully", UVM_LOW)
		else
			`uvm_info(get_full_name, "Payload mismatch", UVM_LOW)

		if(xtn1.parity == xtn2.parity)	
			`uvm_info(get_full_name, "Parity compared successfully", UVM_LOW)
		else
			`uvm_info(get_full_name, "Parity mismatch", UVM_LOW)

endtask

