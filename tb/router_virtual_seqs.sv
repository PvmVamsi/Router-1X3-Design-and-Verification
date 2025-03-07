//virtual seqs
class router_virtual_seqs extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(router_virtual_seqs)
	
	//handle of virtual sequencer
	router_virtual_sequencer vseqrh;
	
	//handle of env_cfg
	router_env_config env_cfg;
	
	//array of src and dst sequenccers
	src_sequencer src_sequencer_h[];
	dst_sequencer dst_sequencer_h[];

	//base sequences
	src_small_seqs src_small_seqs_h;
	

	src_mid_seqs src_mid_seqs_h;
	

	src_big_seqs src_big_seqs_h;
	
	dst_small_delay dst_small_delay_h;
	dst_large_delay dst_large_delay_h;

	bit[1:0]address;

//uvm methods
extern function new(string name = "router_virtual_seqs");
extern task body();
endclass

function router_virtual_seqs::new(string name = "router_virtual_seqs");
	super.new(name);
endfunction

task router_virtual_seqs::body();
	if(!uvm_config_db#(router_env_config) :: get(null,get_full_name(),"router_env_config",env_cfg))
		`uvm_fatal(get_type_name(),"Cant get env_cfg from vseqs");
	if(!uvm_config_db#(bit[1:0]) :: get(null,get_full_name(),"add",address))
		`uvm_fatal(get_type_name(),"Cant get address from vseqs");

	$cast(vseqrh,m_sequencer);
	src_sequencer_h = new[env_cfg.no_of_src];
	dst_sequencer_h = new[env_cfg.no_of_dst];

	foreach(src_sequencer_h[i])
		src_sequencer_h[i] = vseqrh.src_sequencer_h[i];
	foreach(dst_sequencer_h[i])
		dst_sequencer_h[i] = vseqrh.dst_sequencer_h[i];
	//Remove 
	//src_seqs_h = src_seqs::type_id::create("src_seqs_h");
	//dst_seqs_h = dst_seqs::type_id::create("dst_seqs_h");
	//src_seqs_h.start(src_sequencer_h[0]);
	//dst_seqs_h.start(dst_sequencer_h[0]);

endtask


//small packet v seqs
class small_packet_vseqs extends router_virtual_seqs;
	`uvm_object_utils(small_packet_vseqs)
	
	function new(string name = "small_packet_vseqs");
		super.new(name);
	endfunction

	task body();
		super.body();
		src_small_seqs_h = src_small_seqs::type_id::create("src_small_seqs");
		dst_small_delay_h = dst_small_delay::type_id::create("dst_small_delay_h");
		dst_large_delay_h = dst_large_delay ::type_id::create("dst_large_delay_h");

		fork 
		src_small_seqs_h.start(src_sequencer_h[0]);
		dst_small_delay_h.start(dst_sequencer_h[address]);
		//dst_large_delay_h.start(dst_sequencer_h[address]);

		join
		
		//dst_seqs_h.start(dst_sequencer_h[0]);
	endtask
endclass


//mid packet v seqs
class mid_packet_vseqs extends router_virtual_seqs;
	`uvm_object_utils(mid_packet_vseqs)
	
	function new(string name = "mid_packet_vseqs");
		super.new(name);
	endfunction

	task body();
		super.body();
		src_mid_seqs_h = src_mid_seqs::type_id::create("src_mid_seqs");
		dst_small_delay_h = dst_small_delay::type_id::create("dst_small_delay_h");
		dst_large_delay_h = dst_large_delay ::type_id::create("dst_large_delay_h");

		fork
		src_mid_seqs_h.start(src_sequencer_h[0]);
		dst_small_delay_h.start(dst_sequencer_h[address]);
		//dst_large_delay_h.start(dst_sequencer_h[address]);

		join
	endtask
endclass


//big packet v seqs
class big_packet_vseqs extends router_virtual_seqs;
	`uvm_object_utils(big_packet_vseqs)
	
	function new(string name = "big_packet_vseqs");
		super.new(name);
	endfunction

	task body();
		super.body();
		src_big_seqs_h = src_big_seqs::type_id::create("src_big_seqs");
		dst_small_delay_h = dst_small_delay::type_id::create("dst_small_delay_h");
			dst_large_delay_h = dst_large_delay ::type_id::create("dst_large_delay_h");

		fork
		src_big_seqs_h.start(src_sequencer_h[0]);
		dst_small_delay_h.start(dst_sequencer_h[address]);
		//dst_large_delay_h.start(dst_sequencer_h[address]);

		
		join
	endtask
endclass
