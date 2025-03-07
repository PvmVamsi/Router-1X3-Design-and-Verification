//Destination monitor
class dst_monitor extends uvm_monitor;
	//factory registration
	`uvm_component_utils(dst_monitor)
	virtual dst_if.dst_mon vif;
	dst_agt_config m_cfg;
	
	uvm_analysis_port#(dst_xtn) dst_port;
	
//UVM methods
extern function new(string name = "dst_monitor",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass

//Overriding new construct
function dst_monitor :: new(string name = "dst_monitor",uvm_component parent = null);
	super.new(name,parent);
	dst_port = new("dst_port",this);
endfunction

function void dst_monitor::build_phase(uvm_phase phase);
		 if(!uvm_config_db #(dst_agt_config)::get(this,"","dst_agt_config",m_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction



function void dst_monitor::connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
endfunction

task dst_monitor::run_phase(uvm_phase phase);
		forever
		begin 
			collect_data(); 
		end
endtask
task dst_monitor::collect_data(); 
		dst_xtn xtn; 
		xtn = dst_xtn::type_id::create("xtn"); 
		//wait(vif.mon_cb.read_enb == 1);

		while(vif.mon_cb.read_enb !== 1)
			@(vif.mon_cb);
 
//		wait(vif.mon_cb.read_enb == 1)
		@(vif.mon_cb); 
		xtn.header = vif.mon_cb.dout; 
		xtn.payload = new[xtn.header[7:2]]; 
		@(vif.mon_cb); 
		foreach(xtn.payload[i])
			begin
				xtn.payload[i] = vif.mon_cb.dout; 
				@(vif.mon_cb); 
      			end
		
		xtn.parity = vif.mon_cb.dout;
	//	`uvm_info(get_type_name(), $sformatf("Printing from destination monitor %s", xtn.sprint()), UVM_LOW)

		 repeat(2)
			@(vif.mon_cb); 
		`uvm_info(get_type_name(), $sformatf("Printing from destination monitor %s", xtn.sprint()), UVM_LOW)
		dst_port.write(xtn); 


endtask 
	
