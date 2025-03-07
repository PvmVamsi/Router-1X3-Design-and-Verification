//Destination agent
class dst_agt extends uvm_agent;
	//factory registration
	`uvm_component_utils(dst_agt)

	//Handles declaration
	dst_driver dst_driver_h;
	dst_monitor dst_monitor_h;
	dst_sequencer dst_sequencer_h;	
	
	//handle for dst config
	dst_agt_config dst_agt_config_h;
//UVM methods
extern function new(string name = "dst_agt",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

//Overriding new constructor
function dst_agt:: new(string name = "dst_agt",uvm_component parent = null);
	super.new(name,parent);
endfunction


//Build phase
function void dst_agt::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!(uvm_config_db #(dst_agt_config)::get(this,"","dst_agt_config",dst_agt_config_h)))
		`uvm_fatal(get_type_name(),"Can't get the src config ");
	//monitor instance creation
	dst_monitor_h = dst_monitor::type_id::create("dst_monitor_h",this);
	
	if(dst_agt_config_h.is_active == UVM_ACTIVE)begin
		dst_sequencer_h = dst_sequencer::type_id::create("dst_sequencer_h",this);
		dst_driver_h  = dst_driver::type_id::create("dst_driver_h",this);
	end
endfunction

//connect phase
function void dst_agt::connect_phase(uvm_phase phase);
		if(dst_agt_config_h.is_active == UVM_ACTIVE)
			dst_driver_h.seq_item_port.connect(dst_sequencer_h.seq_item_export);
endfunction
