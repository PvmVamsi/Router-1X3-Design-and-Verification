//source sequence
class src_seqs extends uvm_sequence#(src_xtn);
	//factory registration
	`uvm_object_utils(src_seqs)
	bit[1:0] address;

//uvm methods
extern function new(string name ="src_seqs");
endclass

//Overriding new constructor
function src_seqs:: new(string name = "src_seqs");
	super.new(name);
endfunction


//small packet
class src_small_seqs extends src_seqs;
	`uvm_object_utils(src_small_seqs)
	
	function new(string name = "src_small_seqs");
		super.new(name);
	endfunction

	task body();
		req = src_xtn::type_id::create("req");
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"add",address))
			`uvm_fatal(get_type_name(),"can't get the address from config")
		//`uvm_info(get_type_name(),$sforamtf("The address is %0d",address),UVM_LOW)
		$display("====================the address is %0d================= ",address);
		start_item(req);
				assert(req.randomize() with {header[1:0] == address;header[7:2] inside{[1:20]};});
		`uvm_info(get_type_name(),$sformatf("The randomized packet %s",req.sprint()),UVM_LOW)
		finish_item(req);
	endtask


endclass

//medium packet
class src_mid_seqs extends src_seqs;
	`uvm_object_utils(src_mid_seqs)
	
	function new(string name = "src_small_seqs");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"add",address))
			`uvm_fatal(get_type_name(),"can't get the address from config")
			$display("====================the address is %0d================= ",address);

		req = src_xtn::type_id::create("req");
		start_item(req);
			//`uvm_info(get_type_name(),$sforamtf("The address is %0d",address),UVM_LOW)

		assert(req.randomize() with {header[1:0] == address;header[7:2] inside{[21:40]};});
		`uvm_info(get_type_name(),"The randomized packet",UVM_LOW)
		req.print();
		finish_item(req);
	endtask


endclass

//big packet
class src_big_seqs extends src_seqs;
	`uvm_object_utils(src_big_seqs)
	
	function new(string name = "src_small_seqs");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"add",address))
			`uvm_fatal(get_type_name(),"can't get the address from config")
		$display("====================the address is %0d================= ",address);

		req = src_xtn::type_id::create("req");
		start_item(req);
		//`uvm_info(get_type_name(),$sforamtf("The address is %0d",address),UVM_LOW)

		assert(req.randomize() with {header[1:0] == address;header[7:2] inside{[41:63]};});
		`uvm_info(get_type_name(),$sformatf("The randomized packet %s",req.sprint()),UVM_LOW)
		//req.print();
		finish_item(req);
	endtask


endclass


