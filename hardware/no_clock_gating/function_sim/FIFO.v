module FIFO(clk, rst, ifmapIn, canRead, canWrite, ifmapOut, rowWriteAddress, ReadCount);

input clk, rst;
input [63:0] ifmapIn;                // ifmap from DRAM

output canRead, canWrite;            // FIFO read / write signal

output reg [63:0] ifmapOut;          // Complete sliced 64-bit data output to rowRf
output reg [1:0]  rowWriteAddress;   // write Address to row ifmap 
output reg [4:0]  ReadCount;         // Use to check new row is full or not

reg [7:0] index;
assign canWrite = (index<=64) ;      // Read tb data enable
assign canRead  = (index>=64) ;      // Write data to row rowRf enable

reg [127:0] buffer;                  // FIFO size


// Shift 64-bit  64-bit  64-bit  48-bit in one row
reg [6:0] shift;

always@(*)begin
	case(rowWriteAddress)
		0: shift = 7'd64;  // 8 data
		1: shift = 7'd64;  // 8 data
		2: shift = 7'd48;  // 6 data
		3: shift = 7'd64;  // 8 data, start from here
	endcase
end

// --------- FIFO read / write -----------
always@(posedge clk or posedge rst)begin
	if(rst)begin
		index <= 8'd0;
		buffer <= 128'd0;
		ReadCount <= 5'd0;
		ifmapOut <= 64'd0;
		rowWriteAddress <= 2'd3;
	end
	else begin
		if(canWrite) begin             // Read ifmap from tb (DRAM)  
			buffer[index +: 64] <= ifmapIn;
			index <= index + 64;
		end
		else if(canRead) begin         // Rrite to RF row
			ifmapOut <= buffer[63:0];
			buffer <= buffer >> shift;
			index <= index - shift;

			rowWriteAddress <= rowWriteAddress +1;
			ReadCount <= (ReadCount==16)? 5'd1 : ReadCount + 1;
		end
	end
end


endmodule