//environment class
class router_env extends uvm_env;
	`uvm_component_utils(router_env)
	
	//handles of src and dst
	src_agt_top src_agt_top_h;
	dst_agt_top dst_agt_top_h;

	//handles of v sequencer
	router_virtual_sequencer vsqrh;

	//handle of scoreboard
	router_scoreboard sbh;

	//handle for the env config
	router_env_config m_cfg;

//UVM methods
extern function new(string name = "router_env",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function router_env::new(string name = "router_env",uvm_component parent = null);
	super.new(name,parent);
endfunction

function void router_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	//get the m_cfg
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal(get_type_name(),"Cant get the env config");
	
	src_agt_top_h = src_agt_top::type_id::create("src_agt_top_h",this);
	dst_agt_top_h = dst_agt_top::type_id::create("dst_agt_top_h",this);
	vsqrh = router_virtual_sequencer::type_id::create("vsqrh",this);
	sbh = router_scoreboard::type_id::create("sbh",this);
endfunction


function void router_env::connect_phase(uvm_phase phase);
		for(int i = 0;i<m_cfg.no_of_src;i++)
			vsqrh.src_sequencer_h[i] = src_agt_top_h.src_agt_h[i].src_sequencer_h;
		for(int i = 0;i<m_cfg.no_of_dst;i++)
			vsqrh.dst_sequencer_h[i] = dst_agt_top_h.dst_agt_h[i].dst_sequencer_h;
		
		src_agt_top_h.src_agt_h[0].src_monitor_h.src_port.connect(sbh.src_fifoh[0].analysis_export);
		for(int i = 0;i<m_cfg.no_of_dst;i++)
			dst_agt_top_h.dst_agt_h[i].dst_monitor_h.dst_port.connect(sbh.dst_fifoh[i].analysis_export);

endfunction	
