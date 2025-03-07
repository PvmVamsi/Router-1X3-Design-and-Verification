module router_sync(clk,rstn,detect_addrs,din,wr_enb_reg,
                           vld_out_0,vld_out_1,vld_out_2,
                           read_enb_0,read_enb_1,read_enb_2,
                           wr_enb,fifo_full,empty_0,empty_1,empty_2,
                           soft_rst_0,soft_rst_1,soft_rst_2,
                           full_0,full_1,full_2);
                   input clk,rstn,detect_addrs,wr_enb_reg,
									read_enb_0,read_enb_1,read_enb_2,
									full_0,full_1,full_2,
									empty_0,empty_1,empty_2;
                   input [1:0]din;

                   output reg[2:0]wr_enb;
                   output reg fifo_full,soft_rst_0,soft_rst_1,soft_rst_2;
						 output vld_out_0,vld_out_1,vld_out_2;

                   reg [1:0]fifo_addrs;
                   reg [4:0]fifo_0_count_soft_rst;
                   reg [4:0]fifo_1_count_soft_rst;
                   reg [4:0]fifo_2_count_soft_rst;

                   //To capture the destination addrs
                   always@(posedge clk)
                   begin
                           if(!rstn)
												fifo_addrs<=0;
                           else if(detect_addrs)
                                   fifo_addrs<=din;
                           else
                                   fifo_addrs<=fifo_addrs;
                   end

                   //write enab signal 
                   always@(*)
                   begin
                           if(wr_enb_reg)
                           begin
                                   case(fifo_addrs)
                                           2'b00:wr_enb=3'b001;
                                           2'b01:wr_enb=3'b010;
                                           2'b10:wr_enb=3'b100;
                                           default:wr_enb=3'b000;
                                    endcase
                          end
                          else
                                  wr_enb=3'b000;
						end

                    //fifo full logic
                    always@(*)
                    begin
                            case(fifo_addrs)
                                    2'b00:fifo_full=full_0;
                                    2'b01:fifo_full=full_1;
                                    2'b10:fifo_full=full_2;
                                    default:fifo_full=0;
                            endcase
                    end

                    //valid out logic
                    assign vld_out_0=~empty_0;
                    assign vld_out_1=~empty_1;
                    assign vld_out_2=~empty_2;

                    //time out logic(soft rst 0)
                    always@(posedge clk)
                    begin
							if(!rstn)
                            begin
                                    soft_rst_0<=0;
                                    fifo_0_count_soft_rst<=5'd0;
                            end
                            else if(!vld_out_0)
                            begin
                                    soft_rst_0<=0;
                                    fifo_0_count_soft_rst<=5'd0;
                            end
                             if(read_enb_0)
                            begin
                                    soft_rst_0<=0;
                                    fifo_0_count_soft_rst<=5'd0;
                            end
                            else if(fifo_0_count_soft_rst==5'd29)
                            begin
                                    soft_rst_0<=1;
                                    fifo_0_count_soft_rst<=5'd0;
                            end
									else
                            begin
                                    fifo_0_count_soft_rst<=fifo_0_count_soft_rst+1;
                                    soft_rst_0<=0;
                            end
                    end

                    //time out logic(soft rst 1)
                    always@(posedge clk)
						  begin
							if(!rstn)
                            begin
                                    soft_rst_1<=0;
                                    fifo_1_count_soft_rst<=5'd0;
                            end
                            else if(!vld_out_1)
                            begin
                                    soft_rst_1<=0;
                                    fifo_1_count_soft_rst<=5'd0;
                            end
                            else if(read_enb_1)
                            begin
                                    soft_rst_1<=0;
                                    fifo_1_count_soft_rst<=5'd0;
                            end
                            else if(fifo_1_count_soft_rst==5'd29)
                            begin
                                    soft_rst_1<=1;
                                    fifo_1_count_soft_rst<=5'd0;
                            end
									else
                            begin
                                    fifo_1_count_soft_rst<=fifo_1_count_soft_rst+1;
                                    soft_rst_1<=0;
                            end
                    end


                   //time out logic (soft rst 2)
						  always@(posedge clk)
						  begin
							if(!rstn)
                            begin
                                    soft_rst_2<=0;
                                    fifo_2_count_soft_rst<=5'd0;
                            end
                            else if(!vld_out_2)
                            begin
                                    soft_rst_2<=0;
                                    fifo_2_count_soft_rst<=5'd0;
                            end
                            else if(read_enb_2)
                            begin
                                    soft_rst_2<=0;
                                    fifo_2_count_soft_rst<=5'd0;
                            end
                            else if(fifo_2_count_soft_rst==5'd29)
                            begin
                                    soft_rst_2<=1;
                                    fifo_2_count_soft_rst<=5'd0;
                            end
								
		    	    else
                            begin
                                    fifo_2_count_soft_rst<=fifo_2_count_soft_rst+1;
                                    soft_rst_2<=0;
                            end
                    end
		    endmodule

	     








