interface src_if(input bit clk);
	bit[7:0]din;
	logic pkt_valid;
	logic error;
	logic busy;
	bit rstn;
	
	clocking drv_cb @(posedge clk);
		default input #1 output #1;
		output din;
		output pkt_valid;
		output rstn;
		input error;
		input busy;
	endclocking


	clocking mon_cb @(posedge clk);
		default input #1 output #1;
		input  din;
		input pkt_valid;
		input rstn;
		input error;
		input busy;
	endclocking
	
	modport src_drv(clocking drv_cb);
	modport src_mon(clocking mon_cb);

endinterface
