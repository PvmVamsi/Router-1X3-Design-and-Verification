//Source agent top 
class src_agt_top extends uvm_env;
	//factory registration
	`uvm_component_utils(src_agt_top)
	
	//handle for src agents
	src_agt src_agt_h[];
	
	//handle for the env config
	router_env_config m_cfg;

//UVM methods
extern function new(string name = "src_agt_top",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);

endclass

//overriding new construct
function src_agt_top:: new(string name = "src_agt_top",uvm_component parent = null);
	super.new(name,parent);
endfunction

//build_phase
function void src_agt_top:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	//get the m_cfg
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal(get_type_name(),"Cant get the env config");
	
	src_agt_h = new[m_cfg.no_of_src];
	
	foreach(src_agt_h[i]) begin
		src_agt_h[i] = src_agt::type_id::create($sformatf("src_agt_h[%0d]",i),this);
		uvm_config_db #(src_agt_config)::set(this,$sformatf("src_agt_h[%0d]*",i),"src_agt_config",m_cfg.src_agt_config_h[i]);
	end
		
endfunction
