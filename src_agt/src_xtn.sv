//Source transcation class
class src_xtn extends uvm_sequence_item;
	
	//factorty registration
	`uvm_object_utils(src_xtn)

	rand bit[7:0]header;
	rand bit [7:0]payload[];
	rand bit[7:0]parity;
	bit resetn;
	logic error;
	logic pkt_valid;
	logic busy;

	constraint range{header[1:0] != 3;header[7:2]!= 0; payload.size()==header[7:2];}

	function void post_randomize();
			parity = header;
			foreach(payload[i])
					begin
				parity = parity^payload[i];
				end
	endfunction


/*	`uvm_object_utils_begin(src_xtn)
		`uvm_field_int(header, UVM_ALL_ON)	
		`uvm_field_array_int(payload, UVM_ALL_ON) 
		`uvm_field_int(parity, UVM_ALL_ON )
		`uvm_field_int(pkt_valid, UVM_ALL_ON)
		`uvm_field_int(resetn, UVM_ALL_ON)
		`uvm_field_int(error, UVM_ALL_ON)
	`uvm_object_utils_end*/
	
	virtual function void do_print(uvm_printer printer);
		printer.print_field("header", header, 8, UVM_DEC); 
		//payload
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),payload[i],8,UVM_DEC);
		printer.print_field("parity", parity, 8, UVM_DEC); 
				
	endfunction

	

//UVM methods
extern function new(string name = "src_xtn");
	
endclass

//Overriding new constructor
function src_xtn::new(string name = "src_xtn");
		super.new(name);
endfunction



