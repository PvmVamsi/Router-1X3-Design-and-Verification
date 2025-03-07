//Source configuration
class src_agt_config extends uvm_object;
	
	//factory registration
	`uvm_object_utils(src_agt_config)

	virtual src_if vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
//UVM methods 
extern function new(string name = "src_agt_config");
endclass

//Overriding new construnctor
function src_agt_config :: new(string name = "src_agt_config");
	super.new(name);
endfunction
