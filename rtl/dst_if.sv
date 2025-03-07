interface dst_if(input bit clk);
	bit[7:0]dout;
	bit valid_out;
	bit read_enb;

	
	clocking drv_cb @(posedge clk);
		default input #1 output #0;
		output read_enb;
		//output rstn;
		input valid_out;
	endclocking


	clocking mon_cb @(posedge clk);
		default input #1 output #0;
		input  dout;
		input valid_out;
		input read_enb;
		//input error;
		//input busy;
	endclocking
	
	modport dst_drv(clocking drv_cb);
	modport dst_mon(clocking mon_cb);

endinterface
