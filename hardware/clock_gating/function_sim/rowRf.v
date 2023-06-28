module rowRf(clk, rst, writeEn, writeAddr, writeData, readEn, rowOut, fullRow);

input clk, rst, writeEn, readEn, fullRow;
input [63:0] writeData;     // Data write to rowRf from FIFO
input [1:0]  writeAddr;     // Write to rowRf address

output reg [63:0] rowOut;

reg [63:0] buffer [3:0];    // Keep four 64 bit data which means one row data
reg [2:0] readAddr;         // write to PE array address
reg state;
integer i;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		for(i=0; i<4; i=i+1)begin
			buffer[i] <= 64'd0;
		end
		readAddr <= 0;
		rowOut <= 64'd0;
		state <= 0;
	end
	else begin
		if(writeEn)begin
			buffer[writeAddr] <= writeData;
		end
		if(readEn)begin
			case(state)
				0:begin
					rowOut <= buffer[readAddr];
					if(readAddr==3) begin
						state <= 1;
						readAddr <= 3'd0;
					end
					else readAddr <= readAddr + 1;
				end
				1:begin
					if(fullRow) state <= 0;
				end
			endcase 
		end
	end
end

endmodule