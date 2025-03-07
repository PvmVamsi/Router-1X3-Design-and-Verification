//env config
class router_env_config extends uvm_object;
	
	//factory registration
	`uvm_object_utils(router_env_config)
	
	//configuration handles
	src_agt_config src_agt_config_h[];
	dst_agt_config dst_agt_config_h[];
	
	//no of agents
	int no_of_src = 1;
	int no_of_dst = 3;

	
//UVM methods
extern function new(string name = "router_env_config");
endclass

function router_env_config::new(string name = "router_env_config");
		super.new(name);
endfunction
