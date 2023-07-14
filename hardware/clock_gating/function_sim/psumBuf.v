module psumBuf(clk, rst, enable, first, last, psumIn, headAddress, convValid, convResult);

input clk, rst, enable, first, last;
input [175:0] psumIn;
input [5:0] headAddress;
output convValid;
output [31:0] convResult;

reg [23:0] psum [0:31];
reg [5:0] addr;
reg [3:0] count;

wire [23:0] reluResult [0:7];
assign reluResult[0] = (psum[addr-8][23])?  0 : {7'd0, psum[addr-8][23:7]};
assign reluResult[1] = (psum[addr-7][23])?  0 : {7'd0, psum[addr-7][23:7]};
assign reluResult[2] = (psum[addr-6][23])?  0 : {7'd0, psum[addr-6][23:7]};
assign reluResult[3] = (psum[addr-5][23])?  0 : {7'd0, psum[addr-5][23:7]};
assign reluResult[4] = (psum[addr-4][23])?  0 : {7'd0, psum[addr-4][23:7]};
assign reluResult[5] = (psum[addr-3][23])?  0 : {7'd0, psum[addr-3][23:7]};
assign reluResult[6] = (psum[addr-2][23])?  0 : {7'd0, psum[addr-2][23:7]};
assign reluResult[7] = (psum[addr-1][23])?  0 : {7'd0, psum[addr-1][23:7]};

wire [7:0] max [0:3];
assign max[0] = (reluResult[0] > reluResult[1]) ? reluResult[0] : reluResult[1];
assign max[1] = (reluResult[2] > reluResult[3]) ? reluResult[2] : reluResult[3];
assign max[2] = (reluResult[4] > reluResult[5]) ? reluResult[4] : reluResult[5];
assign max[3] = (reluResult[6] > reluResult[7]) ? reluResult[6] : reluResult[7];

assign convValid = (count >= 1 && count <= 4) ? 1 : 0;
assign convResult = {max[3][7:0], max[2][7:0], max[1][7:0], max[0][7:0]};

integer i;
always@(posedge clk)begin
	if(rst)begin
		for(i=0; i<32; i=i+1)begin
			psum[i] <= 24'd0;
		end
		addr <= 5'd0;
		count <= 4'd0;
	end
	else begin
		if(enable)begin
			if(first)begin
				addr <= 0;
				count <= 0;
				for(i=16; i<32; i=i+1)begin
					psum[i] <= 24'd0;
				end
				psum[headAddress]   <= psum[headAddress]   + {{2{psumIn[65]}} , psumIn[65:44]  };
				psum[headAddress+1] <= psum[headAddress+1] + {{2{psumIn[87]}} , psumIn[87:66]  };
				psum[headAddress+2] <= psum[headAddress+2] + {{2{psumIn[109]}}, psumIn[109:88] };
				psum[headAddress+3] <= psum[headAddress+3] + {{2{psumIn[131]}}, psumIn[131:110]};
				psum[headAddress+4] <= psum[headAddress+4] + {{2{psumIn[153]}}, psumIn[153:132]};
				psum[headAddress+5] <= psum[headAddress+5] + {{2{psumIn[175]}}, psumIn[175:154]};
			end
			else if(last)begin
				addr <= addr + 8;
				count <= count + 1;
				psum[headAddress]   <= psum[headAddress]   + {{2{psumIn[21]}} , psumIn[21:0]   };
				psum[headAddress+1] <= psum[headAddress+1] + {{2{psumIn[43]}} , psumIn[43:22]  };
				psum[headAddress+2] <= psum[headAddress+2] + {{2{psumIn[65]}} , psumIn[65:44]  };
				psum[headAddress+3] <= psum[headAddress+3] + {{2{psumIn[87]}} , psumIn[87:66]  };
				psum[headAddress+4] <= psum[headAddress+4] + {{2{psumIn[109]}}, psumIn[109:88] };
				psum[headAddress+5] <= psum[headAddress+5] + {{2{psumIn[131]}}, psumIn[131:110]};
			end
			else begin
				addr <= addr + 8;
				count <= count + 1;
				psum[headAddress]   <= psum[headAddress]   + {{2{psumIn[21]}} , psumIn[21:0]   };
				psum[headAddress+1] <= psum[headAddress+1] + {{2{psumIn[43]}} , psumIn[43:22]  };
				psum[headAddress+2] <= psum[headAddress+2] + {{2{psumIn[65]}} , psumIn[65:44]  };
				psum[headAddress+3] <= psum[headAddress+3] + {{2{psumIn[87]}} , psumIn[87:66]  };
				psum[headAddress+4] <= psum[headAddress+4] + {{2{psumIn[108]}}, psumIn[109:88] };
				psum[headAddress+5] <= psum[headAddress+5] + {{2{psumIn[131]}}, psumIn[131:110]};
				psum[headAddress+6] <= psum[headAddress+6] + {{2{psumIn[153]}}, psumIn[153:132]};
				psum[headAddress+7] <= psum[headAddress+7] + {{2{psumIn[175]}}, psumIn[175:154]};
			end
			
		end
		else begin
			if(convValid)
				count <= count + 1;			
			for(i=0; i<16; i=i+1)begin
				psum[i] <= 24'd0;
			end
			addr <= addr + 8;
		end
	end
end

endmodule