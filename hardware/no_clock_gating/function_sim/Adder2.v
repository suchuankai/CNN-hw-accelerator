module Adder2(clk, rst, Rf1_sum, Rf2_sum, Rf3_sum, psum, toPsumBuf);

input clk, rst;
input [19:0] Rf1_sum, Rf2_sum, Rf3_sum, psum;
output reg [21:0] toPsumBuf;

always@(posedge clk)begin
	toPsumBuf <= ( ({{2{Rf1_sum[19]}}, Rf1_sum} + {{2{Rf2_sum[19]}}, Rf2_sum}) + ({{2{Rf3_sum[19]}}, Rf3_sum} + {{2{psum[19]}}, psum}) );
end


endmodule