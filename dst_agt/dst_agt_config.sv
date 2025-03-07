//Destination configuration
class dst_agt_config extends uvm_object;
	
	//factory registration
	`uvm_object_utils(dst_agt_config)

	virtual dst_if vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
//UVM methods 
extern function new(string name = "dst_agt_config");
endclass

//Overriding new construnctor
function dst_agt_config :: new(string name = "dst_agt_config");
	super.new(name);
endfunction
