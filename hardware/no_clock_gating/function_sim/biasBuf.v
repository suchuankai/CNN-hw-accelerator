module biasBuf(clk, rst, mode, readen, in_index, out_index, datain, dataout);

input clk, rst, readen;
input [2:0] mode;
input [6:0] in_index;
input [63:0] datain;
input [6:0] out_index;

output reg [15:0] dataout;

reg [15:0] buffer [5:0];


always@(posedge clk or posedge rst)begin
	if(rst)begin
		dataout <= 16'd0;
	end
	else begin
		if(readen)begin
			buffer[(in_index<<2)+0] <= datain[15:0 ];
			buffer[(in_index<<2)+1] <= datain[31:16];
			buffer[(in_index<<2)+2] <= datain[47:32];
			buffer[(in_index<<2)+3] <= datain[63:48];
		end
		dataout <= buffer[out_index];
	end
end


endmodule