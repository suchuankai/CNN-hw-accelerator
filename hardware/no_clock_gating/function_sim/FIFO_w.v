module FIFO_w(clk, rst, mode, FIFO_w_En, canWrite, canRead, ifmapIn, ifmapOut, weightAddr);

input clk, rst, FIFO_w_En;
input [2:0] mode;
input [63:0] ifmapIn;                // ifmap from DRAM

output canWrite;
output canRead ;                       // FIFO read / write signal

output reg [71:0] ifmapOut;          // Complete sliced 72-bit data output to weightBuf
output reg [6:0]  weightAddr;        // write Address to row weightBuf 


reg [7:0] index;
assign canWrite = (index<=64) ;      // Read tb data enable
assign canRead  = (index>=72) ;      // Write data to weightBuf enable

reg [127:0] buffer;                  // FIFO size


// --------- FIFO read / write -----------
always@(posedge clk or posedge rst)begin
	if(rst)begin
		index <= 8'd0;
		buffer <= 128'd0;
		ifmapOut <= 71'd0;
		weightAddr <= 7'd127;
	end
	else begin
		if(canWrite && FIFO_w_En) begin        // Read ifmap from tb (DRAM)  
			buffer[index +: 64] <= ifmapIn;
			index <= index + 64;
		end
		if(canRead) begin         // Rrite to weightBuf row
			ifmapOut <= buffer[71:0];
			buffer <= buffer >> 72;
		
			
			index <= index - 72;
			weightAddr <= weightAddr +1;
		end
		if(mode==0 && weightAddr==5) begin
			index <= 0;
			weightAddr <= 7'd127;
		end
	end
end


endmodule