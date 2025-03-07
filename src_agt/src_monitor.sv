//Source monitor
class src_monitor extends uvm_monitor;
	//factory registration
	`uvm_component_utils(src_monitor)
	virtual src_if.src_mon vif;
	
	src_agt_config m_cfg;
	
uvm_analysis_port #(src_xtn) src_port; 
	
	
//UVM methods
extern function new(string name = "src_monitor",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task monitor();
endclass

//Overriding new construct
function src_monitor::new(string name = "src_monitor",uvm_component parent = null);
	super.new(name,parent);
	src_port = new("src_port",this);
endfunction



function void src_monitor::build_phase(uvm_phase phase);
		 if(!uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",m_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction



function void src_monitor::connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
		//`uvm_info("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?",UVM_LOW) 

endfunction


task src_monitor::run_phase(uvm_phase phase);
	forever begin
			monitor();
	
	end
endtask

task src_monitor::monitor();
	src_xtn xtn;	
	xtn = src_xtn::type_id::create("xtn");
	
	while(vif.mon_cb.busy !== 0)
		@(vif.mon_cb);
	
	while(vif.mon_cb.pkt_valid !== 1)
		@(vif.mon_cb);

	xtn.header = vif.mon_cb.din;
	
	

	xtn.payload = new[xtn.header[7:2]];
		@(vif.mon_cb);

	foreach(xtn.payload[i])
		begin
			while(vif.mon_cb.busy !== 0) begin
							@(vif.mon_cb);
			end
	
			xtn.payload[i] = vif.mon_cb.din;
			@(vif.mon_cb);
			
		end
	while(vif.mon_cb.busy !== 0) begin
						@(vif.mon_cb);
			end
	xtn.parity  = vif.mon_cb.din;
	//`uvm_info(get_type_name(),"The data from monitor before error",UVM_LOW)
	 //xtn.print();

	repeat(2) 
	@(vif.mon_cb) ;
	xtn.error = vif.mon_cb.error;
	`uvm_info(get_type_name(),"The data from monitor",UVM_LOW)
	 xtn.print();
	src_port.write(xtn);
endtask   
