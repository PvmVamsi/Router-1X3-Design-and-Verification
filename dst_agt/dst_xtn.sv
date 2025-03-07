//Destination transcation class
class dst_xtn extends uvm_sequence_item;
	
	//factorty registration
	`uvm_object_utils(dst_xtn)
	bit [7:0] header; 
	bit [7:0] payload[];
	bit [7:0] parity; 
	rand bit [5:0] delay; 
	
	
//UVM methods
extern function new(string name = "dst_xtn");

virtual function void do_print(uvm_printer printer);
		printer.print_field("header", header, 8, UVM_DEC); 
		//payload
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),payload[i],8,UVM_DEC);
		printer.print_field("parity", parity, 8, UVM_DEC); 
			printer.print_field("delay", delay, 6, UVM_DEC); 

endfunction


endclass


//Overriding new constructor
function dst_xtn::new(string name = "dst_xtn");
		super.new(name);
endfunction

