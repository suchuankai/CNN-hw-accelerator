module controller(clk, rst, canRead, canWrite, fullRow, psumEn, first, last, headAddress, DRAMreadAddr, memAllready, selectRow);

input clk, rst;

// FIFO input
input canRead, canWrite, fullRow; 
input memAllready; 

// For psumBuf
output reg psumEn, first, last;  
output reg [5:0] headAddress;

// For FIFO
output reg [9:0] DRAMreadAddr;

// For row select
output reg [1:0] selectRow;

// For psum 
reg [3:0] state;
reg [2:0] stateCount;
reg flag; // for state 5 -> state 2 special case


// ------------------ Psum control ----------------------
always@(posedge clk or posedge rst)begin
	if(rst)begin
		psumEn <= 0;
		first <= 0;
		last <= 0;
		headAddress <= 6'd0;

		state <= 4'd0;
		stateCount <= 3'd0;
		flag <= 0;
	end
	else begin
		if(memAllready)begin
			case(state)
				0:begin
					psumEn <= 0;
					if(stateCount==3) begin
						state <= 3;
						stateCount <= 4'd0;
					end
					else begin
						stateCount <= stateCount+1;
					end 
				end
				1:begin
					psumEn <= 0;
					if(fullRow) state <= 2;
				end
				2:begin
					first <= 0;
					if(stateCount==3) begin
						state <= 3;
						stateCount <= 3'd0;
					end
					else begin
						stateCount <= stateCount+1;
					end 
					if(flag)begin
						psumEn <= 1;
						flag <= 0;
						last <= 1;
						headAddress <= headAddress+8;
					end
					else begin
						psumEn <= 0;
						last <= 0;
					end
				end
				3:begin   // psumEn 4 cycle
					state <= 4;
					first <= 1;
					psumEn <= 1;
					headAddress <= 0;
				end
				4:begin
					state <= 5;
					first <= 0;
					headAddress <= headAddress+6;
				end
				5:begin
					if(fullRow) begin
						state <= 2;
						flag <= 1; 
					end
					else state <= 6;
					headAddress <= headAddress+8;
				end
				6:begin
					if(fullRow) state <= 2;
					else state <= 7;
					last <= 1;
					headAddress <= headAddress + 8;
				end
				7:begin
					if(fullRow) state <= 2;
					else state <= 1;
					last <= 0;
					psumEn <= 0;
					headAddress <= 6'd0;
				end
			endcase
		end
	end
end


// ------------------ FIFO control ----------------------
always@(posedge clk or posedge rst)begin
	if(rst)begin
		DRAMreadAddr <= 10'd0;
	end
	else begin
		if(canWrite)
			DRAMreadAddr <= DRAMreadAddr + 1;
	end
end


// ------------------ Row select control ------------------
always@(posedge clk or posedge rst)begin
	if(rst)begin
		selectRow <= 2'd0;
	end
	else begin
		if(fullRow) selectRow <= selectRow + 1;
	end
end


endmodule