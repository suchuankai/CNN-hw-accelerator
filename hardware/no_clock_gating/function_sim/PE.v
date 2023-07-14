module PE(clk, rst, ifmap, filter, psumIn, psumOut);

input clk, rst;
input [7:0] ifmap, filter;
input [19:0] psumIn;
output [19:0] psumOut;

reg [7:0] ifmapBuf;
reg signed [7:0]  filterBuf;
reg signed [15:0] mulBuf;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		ifmapBuf  <= 8'd0;
		filterBuf <= 8'd0;
		mulBuf    <= 16'd0;
	end
	else begin
		// Stage 1 -> get ifmap and filter value
		ifmapBuf  <= ifmap;
		filterBuf <= filter;

		// Stage 2 ->  multiply and save result in mulBuf
		mulBuf <= $signed({1'b0, ifmapBuf}) * filterBuf;
	end
end

// Stage 3 -> Output partialsum in this PE
assign psumOut = {{4{mulBuf[15]}}, mulBuf} + psumIn;

endmodule