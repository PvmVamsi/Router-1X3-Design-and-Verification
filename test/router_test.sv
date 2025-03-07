//test class
class router_test extends uvm_test;
	//factory reg
	`uvm_component_utils(router_test)
	
	//handles of config
	router_env_config env_cfg;
	src_agt_config src_agt_config_h[];
	dst_agt_config dst_agt_config_h[];
	
	//no of agents
	int no_of_src = 1;
	int no_of_dst = 3;
	
	//env handle
	router_env envh;
	
	router_virtual_seqs vseqsh;

	bit[1:0] address;

//uvm methods
extern function new(string name = "router_test",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function router_test:: new(string name = "router_test",uvm_component parent = null);
	super.new(name,parent);
endfunction

//build phase
function void router_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	envh = router_env :: type_id :: create("envh",this);
	env_cfg = router_env_config::type_id::create("env_cfg");
	
	src_agt_config_h = new[no_of_src];
	dst_agt_config_h = new[no_of_dst];

	env_cfg.no_of_src  = no_of_src;
	env_cfg.no_of_dst  = no_of_dst;
	
	env_cfg.src_agt_config_h = new[no_of_src];
	env_cfg.dst_agt_config_h = new[no_of_dst];

	foreach(src_agt_config_h[i])begin
		src_agt_config_h[i] = src_agt_config::type_id::create($sformatf("src_agt_config_h[%0d]",i));
		src_agt_config_h[i].is_active = UVM_ACTIVE;
		
		if(!uvm_config_db#(virtual src_if)::get(this,"",$sformatf("src_if_%0d",i),src_agt_config_h[i].vif))
			`uvm_fatal("fgh","Cant get the env config");
		env_cfg.src_agt_config_h[i] = src_agt_config_h[i];
	end

	
	foreach(dst_agt_config_h[i])begin
		dst_agt_config_h[i] = dst_agt_config::type_id::create($sformatf("dst_agt_config_h[%0d]",i));
		dst_agt_config_h[i].is_active = UVM_ACTIVE;

		if(!uvm_config_db#(virtual dst_if)::get(this,"",$sformatf("dst_if_%0d",i),dst_agt_config_h[i].vif))
			`uvm_fatal(get_type_name(),"cant get dst if")

		env_cfg.dst_agt_config_h[i] = dst_agt_config_h[i];
	end
	uvm_config_db #(router_env_config) :: set(this,"*","router_env_config",env_cfg);

		//address = {$urandom}%3;
		//	uvm_config_db#(bit[1:0])::set(this,"*","add",address);
		
endfunction

//topology
function void router_test::end_of_elaboration_phase(uvm_phase phase);
 	uvm_top.print_topology();
endfunction

task router_test::run_phase(uvm_phase phase);
	vseqsh = router_virtual_seqs :: type_id::create("vseqsh");	
	phase.raise_objection(this);
	vseqsh.start(envh.vsqrh);
	phase.drop_objection(this);
endtask
	

///small packet test
class small_packet_test extends router_test;
	`uvm_component_utils(small_packet_test)
	 small_packet_vseqs small_vseqsh;
	//bit[1:0] address;
	
	function new(string name = "small_packet_test",uvm_component parent );
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		  super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		//super.run_phase(phase);
		
		phase.raise_objection(this);
			repeat(4) begin
				address = {$urandom}%3;
			uvm_config_db#(bit[1:0])::set(this,"*","add",address);

			small_vseqsh = small_packet_vseqs :: type_id::create("small_vseqsh");
			small_vseqsh.start(envh.vsqrh);
			#50;
			end
		phase.drop_objection(this);
	endtask
endclass
	

//medium packet test
class mid_packet_test extends router_test;
	`uvm_component_utils(mid_packet_test)
	 mid_packet_vseqs mid_vseqsh;
	function new(string name = "mid_packet_test",uvm_component parent );
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		  super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		//super.run_phase(phase);
		phase.raise_objection(this);
			repeat(2) begin
			address = {$urandom}%3;
		     uvm_config_db#(bit[1:0])::set(this,"*","add",address);

			mid_vseqsh = mid_packet_vseqs :: type_id::create("mid_vseqsh");
			mid_vseqsh.start(envh.vsqrh);
			#50;
			end
		phase.drop_objection(this);
	endtask
endclass



//big packet test
class big_packet_test extends router_test;
	`uvm_component_utils(big_packet_test)
	 big_packet_vseqs big_vseqsh;
	function new(string name = "big_packet_test",uvm_component parent );
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		  super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		//super.run_phase(phase);
		phase.raise_objection(this);
			big_vseqsh = big_packet_vseqs :: type_id::create("big_vseqsh");
				address = {$random}%3;
			uvm_config_db#(bit[1:0])::set(this,"*","add",address);


		        big_vseqsh.start(envh.vsqrh);
			#50;				
		phase.drop_objection(this);
	endtask
endclass		
