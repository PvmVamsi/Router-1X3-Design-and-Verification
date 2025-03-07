//Destination agent top 
class dst_agt_top extends uvm_env;
	//factory registration
	`uvm_component_utils(dst_agt_top)
	
	//handle for dst agents
	dst_agt dst_agt_h[];
	
	//handle for the env config
	router_env_config m_cfg;

//UVM methods
extern function new(string name = "dst_agt_top",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
endclass

//overriding new construct
function dst_agt_top::new(string name = "dst_agt_top",uvm_component parent = null);
	super.new(name,parent);
endfunction

//build_phase
function void dst_agt_top:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	//get the m_cfg
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal(get_type_name(),"Cant get the env config");
	
	dst_agt_h = new[m_cfg.no_of_dst];
	
	foreach(dst_agt_h[i]) begin
		dst_agt_h[i] = dst_agt::type_id::create($sformatf("dst_agt_h[%0d]",i),this);
		uvm_config_db #(dst_agt_config)::set(this,$sformatf("dst_agt_h[%0d]*",i),"dst_agt_config",m_cfg.dst_agt_config_h[i]);
	end
		
endfunction
