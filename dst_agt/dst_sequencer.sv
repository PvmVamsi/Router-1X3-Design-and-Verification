//Destination sequencer
class dst_sequencer extends uvm_sequencer#(dst_xtn);
	//factory registration
	`uvm_component_utils(dst_sequencer)
	
//UVM methods
extern function new(string name = "dst_sequencer",uvm_component parent = null);
endclass

//Overriding new construct
function dst_sequencer::new(string name = "dst_sequencer",uvm_component parent = null);
	super.new(name,parent);
endfunction
