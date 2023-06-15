module RfTemp(clk, rst, In1, In2, In3, In4, In5, In6, In7, In8, In9, In10, Out1, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9, Out10);

input clk, rst;
input  [19:0] In1, In2, In3, In4, In5, In6, In7, In8, In9, In10;
output reg [19:0] Out1, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9, Out10;

always@(posedge clk)begin
	if(rst)begin
		Out1  <= 20'd0;
		Out2  <= 20'd0;
		Out3  <= 20'd0;
		Out4  <= 20'd0;
		Out5  <= 20'd0;
		Out6  <= 20'd0;
		Out7  <= 20'd0;
		Out8  <= 20'd0;
		Out9  <= 20'd0;
		Out10 <= 20'd0;
	end
	else begin
		Out1  <= In1;
		Out2  <= In2;
		Out3  <= In3;
		Out4  <= In4;
		Out5  <= In5;
		Out6  <= In6;
		Out7  <= In7;
		Out8  <= In8;
		Out9  <= In9;
		Out10 <= In10;
	end
end

endmodule