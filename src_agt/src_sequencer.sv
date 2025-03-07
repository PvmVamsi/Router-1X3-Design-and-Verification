//Source sequencer
class src_sequencer extends uvm_sequencer#(src_xtn);
	//factory registration
	`uvm_component_utils(src_sequencer)
	
//UVM methods
extern function new(string name = "src_sequencer",uvm_component parent = null);
endclass

//Overriding new construct
function src_sequencer::new(string name = "src_sequencer",uvm_component parent = null);
	super.new(name,parent);
endfunction
