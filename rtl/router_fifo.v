module router_fifo(clk,rst,sft_rst,wr_en,rd_en,lfd_state,din,full,empty,dout);
   input clk,rst,sft_rst,wr_en,rd_en,lfd_state;
   input [7:0]din;
   output full,empty;
   output reg [7:0]dout;
   reg [4:0]rd_ptr,wr_ptr;
   reg [6:0]fifo_count;
   reg lfd_state_s;
   integer i,j;

   reg [8:0]mem[0:15];
   //delay lfd_state
   always@(posedge clk)
   begin
	   if(!rst)
		   lfd_state_s<=0;
	   else
		   lfd_state_s<=lfd_state;
   end
   //increment wr_logic
   always@(posedge clk)
   begin
	   if(!rst)
		   {wr_ptr,rd_ptr}<=0;
	   else if(sft_rst)
		   {wr_ptr,rd_ptr}<=0;
	   else if(wr_en==1'b1 && !full)
		   wr_ptr<=wr_ptr+1;
	   else if(rd_en==1'b1 && !empty)
		   rd_ptr<=rd_ptr+1;
   end

   //fifo write logic
   always@(posedge clk)
   begin
	   if(!rst)
	   begin
		   for(i=0;i<16;i=i+1)
			   mem[i]<=0;
	   end
	   else if(sft_rst)
	   begin
		   for(j=0;j<16;j=j+1)
			   mem[j]<=0;
	   end
	   else if(wr_en==1'b1 && !full)
		   mem[wr_ptr[3:0]]<={lfd_state_s,din};
   end
   //fifo down logic
   always@(posedge clk)
   begin
	   if(!rst)
		   fifo_count<=7'b0;
	   else if(sft_rst)
		   fifo_count<=7'b0;
	   else if(rd_en==1'b1 && !empty)
	   begin
		   if(mem[rd_ptr[3:0]][8]==1)
			   fifo_count<=mem[rd_ptr[3:0]][7:2]+1'b1;
		   else if(fifo_count!=0)
			   fifo_count<=fifo_count-7'b1;
	   end
   end

   //FIFO READ
   always@(posedge clk)
   begin
	   if(!rst)
		   dout<=8'b0;
	   if(sft_rst)
		   dout<=8'b0;
	   else if(fifo_count==0 && dout!=0)
		   dout<=8'bz;
	   else if(rd_en==1'b1 && !empty)
		   dout<=mem[rd_ptr[3:0]];
   end

   assign full=(wr_ptr[3:0]==rd_ptr[3:0]  && wr_ptr[4] != rd_ptr[4])?1'b1:1'b0;
   assign empty=(wr_ptr[3:0]==rd_ptr[3:0] && wr_ptr[4] == rd_ptr[4])?1'b1:1'b0;
	//assign full=(wr_ptr==16 && rd_ptr==0)?1'b1:1'b0;
	//assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
   endmodule


