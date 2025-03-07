//Source agent
class src_agt extends uvm_agent;
	//factory registration
	`uvm_component_utils(src_agt)

	//Handles declaration
	src_driver src_driver_h;
	src_monitor src_monitor_h;
	src_sequencer src_sequencer_h;	
	
	//handle for src config
	src_agt_config src_agt_config_h;
//UVM methods
extern function new(string name = "src_agt",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

//Overriding new constructor
function src_agt:: new(string name = "src_agt",uvm_component parent = null);
	super.new(name,parent);
endfunction


//Build phase
function void src_agt::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!(uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",src_agt_config_h)))
		`uvm_fatal(get_type_name(),"Can't get the src config ");
	//monitor instance creation
	src_monitor_h = src_monitor::type_id::create("src_monitor_h",this);
	
	if(src_agt_config_h.is_active == UVM_ACTIVE)begin
		src_sequencer_h = src_sequencer::type_id::create("src_sequencer_h",this);
		src_driver_h  = src_driver::type_id::create("src_driver_h",this);
	end
endfunction

//connect phase
function void src_agt::connect_phase(uvm_phase phase);
		if(src_agt_config_h.is_active == UVM_ACTIVE)
			src_driver_h.seq_item_port.connect(src_sequencer_h.seq_item_export);
endfunction
