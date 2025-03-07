//Destination sequence
class dst_seqs extends uvm_sequence#(dst_xtn);
	//factory registration
	`uvm_object_utils(dst_seqs)


//uvm methods
extern function new(string name ="dst_seqs");
endclass

//Overriding new constructor
function dst_seqs :: new(string name = "dst_seqs");
	super.new(name);
endfunction
class dst_small_delay extends dst_seqs; 
	`uvm_object_utils(dst_small_delay); 
	
	function new(string name = "dst_small_delay"); 
		super.new(name); 
	endfunction 

	task body();

 		begin 
		req = dst_xtn::type_id::create("req"); 
		start_item(req); 
		assert(req.randomize() with {delay inside {[2:28]};});
		finish_item(req);
		end 
	endtask 

endclass

class dst_large_delay extends dst_seqs; 
	`uvm_object_utils(dst_large_delay)
	
	function new(string name = "dst_large_delay"); 
		super.new(name); 
	endfunction 

	task body(); 
	//	assert(uvm_config_db #(tb_config)::get(this, "", "tb_config", m_cfg)); 
		req = dst_xtn::type_id::create("req"); 
		start_item(req); 
		assert(req.randomize() with {delay inside {[50:60]};}); 
		finish_item(req); 
	endtask 
endclass  
