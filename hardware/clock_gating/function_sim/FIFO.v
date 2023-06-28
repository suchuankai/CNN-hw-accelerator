module FIFO(clk, rst, ifmapIn, canRead, canWrite, ifmapOut, toMem0, toMem1, toMem2, toMem3, rowWriteAddress, memAllready, fullRow);

input clk, rst;
input [63:0] ifmapIn;                       // ifmap from DRAM

output canRead, canWrite;                   // FIFO read / write signal
output reg toMem0, toMem1, toMem2, toMem3;  // rowRf enable signal

output reg [63:0] ifmapOut;                 // Complete sliced 64-bit data output to rowRf
output reg [1:0] rowWriteAddress;           // write Address to row ifmap 

output reg memAllready;                     // First three row ready signal
output reg fullRow;                         // Use to check new row is full or not 

reg [7:0] index;
assign canWrite = (index<=64) ;             // Read tb data enable
assign canRead  = (index>=64) ;             // Write data to row rowRf enable


reg [4:0]  ReadCount;   // Use to check new row is full or not
reg [127:0] buffer;     // FIFO size


// Shift 64-bit  64-bit  64-bit  48-bit in one row
reg [2:0] counter;
reg [6:0] shift;

always@(*)begin
	case(counter)
		0: shift = 64;  // 8 data
		1: shift = 64;  // 8 data
		2: shift = 64;  // 8 data
		3: shift = 48;  // 6 data
		default: shift = 64;
	endcase
end

// --------- FIFO read / write -----------
always@(posedge clk or posedge rst)begin
	if(rst)begin
		index <= 8'd0;
		counter <= 3'd0;
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

			counter <= (counter==3)? 3'd0 : counter + 1;
			rowWriteAddress <= rowWriteAddress +1;
			ReadCount <= (ReadCount==16)? 5'd1 : ReadCount + 1;
		end
	end
end


// ------------- new row check -------------
reg [1:0] state;
always@(posedge clk or posedge rst)begin
	if(rst)begin
		state <= 2'd0;
		fullRow <= 0;
		memAllready <= 0; 
	end
	else begin
		case(state)
			0:begin
				if(ReadCount==4)begin
					state <= 1;
					if(memAllready)
						fullRow <= 1;
				end
				else begin
					fullRow <= 0;
				end
			end
			1:begin
				if(ReadCount==8)begin
					state <= 2;
					if(memAllready)
						fullRow <= 1;
				end
				else begin
					fullRow <= 0;
				end
			end
			2:begin
				if(ReadCount==12)begin
					state <= 3;
					if(memAllready)
						fullRow <= 1;
					memAllready <= 1;
				end
				else begin
					fullRow <= 0;
				end
			end
			3:begin
				if(ReadCount==16)begin
					state <= 0;
					if(memAllready)
						fullRow <= 1;
				end
				else begin
					fullRow <= 0;
				end
			end
		endcase
	end
end


// ------------- rowRf select -------------
always@(*)begin
	case(state)
		0:begin
			toMem0 = 1;
			toMem1 = 0;
			toMem2 = 0;
			toMem3 = 0;
		end
		1:begin
			toMem0 = 0;
			toMem1 = 1;
			toMem2 = 0;
			toMem3 = 0;
		end
		2:begin
			toMem0 = 0;
			toMem1 = 0;
			toMem2 = 1;
			toMem3 = 0;
		end
		3:begin
			toMem0 = 0;
			toMem1 = 0;
			toMem2 = 0;
			toMem3 = 1;
		end
	endcase
end


endmodule