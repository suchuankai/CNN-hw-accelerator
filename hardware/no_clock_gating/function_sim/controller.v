module controller(clk, rst, canRead, canWrite, fullRow, psumEn, first, last, headAddress, 
	              DRAMreadAddr, DRAMreadEn, ReadCount, selectRow, toMem0, toMem1, toMem2, toMem3);

input clk, rst;
output DRAMreadEn;

assign DRAMreadEn = 1;

// FIFO input
input canRead, canWrite;  
input [4:0] ReadCount;

// For psumBuf
output reg psumEn, first, last;  
output reg [5:0] headAddress;

// For FIFO
output reg [9:0] DRAMreadAddr;

// For row select
output reg [1:0] selectRow;
output reg toMem0, toMem1, toMem2, toMem3;  // rowRf enable signal
output reg fullRow;                         // Use to check new row is full or not 
reg threeRowready;                          // First three row ready signal

// For psum 
reg [3:0] psumState;
reg [2:0] sendCount, processCount;



// ------------------ Psum control ----------------------
always@(posedge clk or posedge rst)begin
	if(rst)begin
		psumEn <= 0;
		first <= 0;
		last <= 0;
		headAddress <= 6'd0;

		psumState <= 4'd0;
		sendCount <= 3'd0;
		processCount <= 3'd0;
	end
	else begin
		case(psumState)
			0:begin  // Wait first three row ready
				if(threeRowready) psumState <= 1;
			end
			1:begin   
				if(sendCount==3) psumState <= 2;
				sendCount <= (sendCount==3)? 0 : sendCount + 1;
			end
			2:begin
				case(processCount)
					0:begin
						psumEn <= 1;
						first <= 1;
					end
					1:begin
						first <= 0;
						headAddress <= headAddress + 6;
					end
					2:begin
						headAddress <= headAddress + 8;
						if(fullRow) sendCount <= 2;
					end
					3:begin
						last <= 1;
						headAddress <= headAddress + 8;
						if(fullRow) sendCount <= 1;
					end
					4:begin
						last <= 0;
						psumEn <= 0;
						headAddress <= 0;
						psumState <= 1;
					end
				endcase
				processCount <= (processCount==4)? 0 : processCount + 1;
			end
		endcase
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
reg [1:0] rowState;
always@(posedge clk or posedge rst)begin
	if(rst)begin
		rowState <= 2'd0;
		fullRow <= 0;
		threeRowready <= 0; 
	end
	else begin
		case(rowState)
			0:begin
				if(ReadCount==4)begin
					rowState <= 1;
				end
			end
			1:begin
				if(ReadCount==8)begin
					rowState <= 2;
				end
			end
			2:begin
				if(ReadCount==12)begin
					rowState <= 3;
					threeRowready <= 1;
				end
			end
			3:begin
				if(ReadCount==16)begin
					rowState <= 0;
				end
			end
		endcase
	end
end

// ------------- rowRf select -------------

always@(posedge clk or posedge rst)begin
	if(rst)begin
		selectRow <= 2'd0;
	end
	else begin
		if(fullRow) selectRow <= selectRow + 1;
	end
end

always@(*)begin
	case(rowState)
		0:begin
			toMem0 = 1;
			toMem1 = 0;
			toMem2 = 0;
			toMem3 = 0;
			fullRow = (threeRowready && ReadCount==4)? 1 : 0;
		end
		1:begin
			toMem0 = 0;
			toMem1 = 1;
			toMem2 = 0;
			toMem3 = 0;
			fullRow = (threeRowready && ReadCount==8)? 1 : 0;
		end
		2:begin
			toMem0 = 0;
			toMem1 = 0;
			toMem2 = 1;
			toMem3 = 0;
			fullRow = (threeRowready && ReadCount==12)? 1 : 0;
		end
		3:begin
			toMem0 = 0;
			toMem1 = 0;
			toMem2 = 0;
			toMem3 = 1;
			fullRow = (threeRowready && ReadCount==16)? 1 : 0;
		end
	endcase
end

endmodule