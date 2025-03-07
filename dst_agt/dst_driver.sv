//Destination driver
class dst_driver extends uvm_driver#(dst_xtn);
	//factory registration
	`uvm_component_utils(dst_driver)
	virtual dst_if.dst_drv vif;
	dst_agt_config m_cfg;

//UVM methods
extern function new(string name = "dst_driver",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(dst_xtn xtn);
endclass

//Overriding new construct
function dst_driver::new(string name = "dst_driver",uvm_component parent = null);
	super.new(name,parent);
endfunction

function void dst_driver::build_phase(uvm_phase phase);
		 if(!uvm_config_db #(dst_agt_config)::get(this,"","dst_agt_config",m_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction



function void dst_driver::connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
endfunction

task dst_driver::run_phase(uvm_phase phase); 
		forever 
			begin 
				seq_item_port.get_next_item(req); 
				send_to_dut(req); 
				seq_item_port.item_done(); 
			end
endtask 

task dst_driver::send_to_dut(dst_xtn xtn); 
		while(vif.drv_cb.valid_out !== 1)
			@(vif.drv_cb);
		repeat(xtn.delay)
			@(vif.drv_cb); 
		
		vif.drv_cb.read_enb <= 1'b1;
			@(vif.drv_cb); 

	//	wait(vif.drv_cb.vld_out == 0);
		while(vif.drv_cb.valid_out !==0)
		@(vif.drv_cb);
	
		//@(vif.drv_cb); 
		vif.drv_cb.read_enb <= 1'b0; 
		`uvm_info(get_type_name(), $sformatf("Printing from destination driver 1 %s", xtn.sprint()), UVM_LOW)
endtask 
