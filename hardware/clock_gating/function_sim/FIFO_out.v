module FIFO_out(clk, rst, clear, enCounter, maxpoolIn, maxpoolOut, maxpoolOutAddr, DRAMwriteEn);

input clk, rst, clear;
input [3:0] enCounter;    // 6 or 8 for output
input [63:0] maxpoolIn;

output reg [9:0] maxpoolOutAddr;
output reg [63:0] maxpoolOut;
output reg DRAMwriteEn;

reg [113:0] buffer;
reg [6:0] index;
reg [10:0] outCounter;


assign canOutput = (index>=64) ;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		buffer <= 114'd0;
		index <= 7'd0;
		maxpoolOutAddr <= 10'd238;
		DRAMwriteEn <= 0;
		outCounter <= 0;
	end
	else begin
		if(outCounter==24)begin   // Output remain 32 bit
			index <= 7'd0;
			maxpoolOut <= buffer[63:0];
			if(DRAMwriteEn)begin
				maxpoolOutAddr <= maxpoolOutAddr+1;
			end
			outCounter <= 0;
		end
		else begin
			if(canOutput)begin
				maxpoolOut <= buffer[63:0];
				index <= index - 64;
				buffer <= buffer >> 64;
				DRAMwriteEn <= 1;
				outCounter <= outCounter + 1;
				if(DRAMwriteEn)begin
					maxpoolOutAddr <= maxpoolOutAddr+1;
				end
			end
			if(enCounter == 6)begin    // Read 64 bit data
				buffer[index +: 64] <= maxpoolIn;
				index <= index + 64;
			end 
			if(enCounter == 8)begin    // Read 48 bit data
				buffer[index +: 48] <= maxpoolIn[47:0];
				index <= index + 48;
			end
		end
	end
end

endmodule