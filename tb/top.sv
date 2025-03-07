module top;
	import router_pkg::*;
	import uvm_pkg::*;
	
	// Generate clock signal
	bit clk;  
	always 
		#10 clk=!clk; 
	
	//instantiate interfaces
	src_if in0(clk);
	dst_if in1(clk);
	dst_if in2(clk);
	dst_if in3(clk);


	router_top DUV(.clock(clk),.resetn(in0.rstn),.pkt_valid(in0.pkt_valid),.read_enb_0(in1.read_enb),.read_enb_1(in2.read_enb),.read_enb_2(in3.read_enb),.data_in(in0.din),.busy(in0.busy),.error(in0.error),.valid_out_0(in1.valid_out),.valid_out_1(in2.valid_out),.valid_out_2(in3.valid_out),.data_out_0(in1.dout),.data_out_1(in2.dout),.data_out_2(in3.dout));

//router_top DUV(.clk(clk),.resetn(in0.rstn),.packet_valid(in0.pkt_valid),.read_enb_0(in1.read_enb),.read_enb_1(in2.read_enb),.read_enb_2(in3.read_enb),.datain(in0.din),.busy(in0.busy),.err(in0.error),.vldout_0(in1.valid_out),.vldout_1(in2.valid_out),.vldout_2(in3.valid_out),.data_out_0(in1.dout),.data_out_1(in2.dout),.data_out_2(in3.dout));



	initial begin
		`ifdef VCS
         $fsdbDumpvars(0, top);
        `endif


		uvm_config_db#(virtual src_if)::set(null,"*","src_if_0",in0);
		uvm_config_db#(virtual dst_if)::set(null,"*","dst_if_0",in1);
		uvm_config_db#(virtual dst_if)::set(null,"*","dst_if_1",in2);
		uvm_config_db#(virtual dst_if)::set(null,"*","dst_if_2",in3);

		run_test();
	end





	property pkt_vld;
		@(posedge clk) $rose(in0.pkt_valid) |=>in0.busy;
	endproperty

	property stable; 
		@(posedge clk) in0.busy |=> $stable(in0.din); 
	endproperty 

	property rd_enb1; 
		@(posedge clk) $rose(in1.valid_out) |=> ##[0:29] (in1.read_enb);
	endproperty 

	property rd_enb2; 
		@(posedge clk) $rose(in2.valid_out) |=> ##[0:29] (in2.read_enb);
	endproperty 	

	property rd_enb3; 
		@(posedge clk) $rose(in3.valid_out) |=> ##[0:29] (in3.read_enb);
	endproperty 	

/*	
	property vld_out1; 
	//	@(posedge clock) 
			bit[1:0]addr;
        	@(posedge clk) ($rose(in0.pkt_valid)addr = in.data_in[1:0]) ##3 (addr==0) | ->in0.v_out;	
	endproperty 

	property vld_out2; 
	//	@(posedge clock) 
			bit[1:0]addr;
        	@(posedge clk) ($rose(in.pkt_valid)addr = in.data_in[1:0]) ##3 (addr==0) | ->in0.v_out;	
	endproperty 

	property vld_out2; 
	//	@(posedge clock) 
			bit[1:0]addr;
        	@(posedge clk) ($rose(in.pkt_valid)addr = in.data_in[1:0]) ##3 (addr==0) | ->in0.v_out;	
	endproperty 
	*/

	property valid ; 
		@(posedge clk)
        	$rose(in0.pkt_valid)|->##3 in1.valid_out| in2.valid_out| in3.valid_out;
	endproperty 

	property read_1;
        	@(posedge clk)
        	$fell(in1.valid_out) |=> $fell(in1.read_enb);
	endproperty

	property read_2;
      //  bit[1:0]addr;
        	@(posedge clk)
       		 $fell(in2.valid_out) |=> $fell(in2.read_enb);
	endproperty

	property read_3;
      //  bit[1:0]addr;
      		  @(posedge clk)
        	$fell(in3.valid_out) |=> $fell(in3.read_enb);
	endproperty


	pkt_valid: cover property(pkt_vld); 
	stable_data_in: cover property(stable); 
	read_enb1: cover property (rd_enb1); 
	read_enb2: cover property (rd_enb2); 
	read_enb3: cover property (rd_enb3); 
	valid_out: cover property (valid); 	
	vld_out_read1: cover property(read_1); 
	vld_out_read2: cover property(read_2); 
	vld_out_read3: cover property(read_3); 
	



	
	
endmodule

