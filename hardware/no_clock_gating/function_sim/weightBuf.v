module weightBuf(clk, rst, readen, in_index, out_index, datain, dataout);

input clk, rst, readen;
input [6:0] in_index;
input [71:0] datain;
input [6:0] out_index;

output reg [71:0] dataout;

reg [71:0] buffer [20:0];


always@(posedge clk or posedge rst)begin
	if(rst)begin
		dataout <= 16'd0;
	end
	else begin
		if(readen)begin
			buffer[in_index] <= datain;
		end
		dataout <= buffer[out_index];
	end
end


endmodule