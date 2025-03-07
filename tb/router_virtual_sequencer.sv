class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item); 

	`uvm_component_utils(router_virtual_sequencer)
	//env config
	router_env_config env_cfg;
	
	//sequencers 
	src_sequencer src_sequencer_h[]; 
	dst_sequencer dst_sequencer_h[];

//uvm methods 
extern function new(string name = "router_virtual_sequencer", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);

endclass


function router_virtual_sequencer::new(string name = "router_virtual_sequencer", uvm_component parent = null);
		super.new(name, parent); 
endfunction 


function void router_virtual_sequencer:: build_phase(uvm_phase phase); 
		super.build_phase(phase); 
		
		if(!uvm_config_db #(router_env_config) :: get(this,"","router_env_config",env_cfg))
			`uvm_fatal(get_type_name(),"Cant get the env config from vseqr");
		src_sequencer_h = new[env_cfg.no_of_src]; 
		dst_sequencer_h = new[env_cfg.no_of_dst]; 
		
endfunction 

	
 

