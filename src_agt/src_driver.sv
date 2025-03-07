//Source driver
class src_driver extends uvm_driver#(src_xtn);
	//factory registration
	`uvm_component_utils(src_driver)

	virtual src_if.src_drv vif;
	src_agt_config m_cfg;

//UVM methods
extern function new(string name = "src_driver",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task driving(src_xtn xtn);
endclass

//Overriding new construct
function src_driver::new(string name = "src_driver",uvm_component parent = null);
	super.new(name,parent);
endfunction

function void src_driver::build_phase(uvm_phase phase);
		 if(!uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",m_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction



function void src_driver::connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
endfunction

task src_driver::run_phase(uvm_phase phase);


	forever begin
	seq_item_port.get_next_item(req);
	driving(req);
	seq_item_port.item_done(req);
	end
endtask

task src_driver::driving(src_xtn xtn);

	//Reset signal
	@(vif.drv_cb)
	vif.drv_cb.rstn <= 1'b0;
	@(vif.drv_cb)
	vif.drv_cb.rstn <= 1'b1;

	//wait for the busy signal to be deasserted
	while(vif.drv_cb.busy!==0)
		@(vif.drv_cb);

	//header
	vif.drv_cb.pkt_valid<=	1;
	vif.drv_cb.din<=xtn.header;
	@(vif.drv_cb);


	//payload
	foreach(xtn.payload[i]) begin
		while(vif.drv_cb.busy!==0)
		    @(vif.drv_cb);
		
		vif.drv_cb.din<=xtn.payload[i];
		@(vif.drv_cb);
	
	end
	
	//parity
	
		while(vif.drv_cb.busy!==0)
		    @(vif.drv_cb);

	vif.drv_cb.pkt_valid <= 0;
	vif.drv_cb.din<=xtn.parity;	
	@(vif.drv_cb);
	//xtn.print();
endtask
