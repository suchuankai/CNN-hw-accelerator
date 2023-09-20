module demux1_3(Data_in, sel, Data_out_0, Data_out_1, Data_out_2);

input [63:0] Data_in; 
input [1:0]  sel;
output reg [63:0] Data_out_0, Data_out_1, Data_out_2;

always@(*)begin
	case(sel)
		0:begin
			Data_out_0 = Data_in;
			Data_out_1 = 0;
			Data_out_2 = 0;
		end
		1:begin
			Data_out_0 = 0;
			Data_out_1 = Data_in;
			Data_out_2 = 0;
		end
		2:begin
			Data_out_0 = 0;
			Data_out_1 = 0;
			Data_out_2 = Data_in;
		end
		default:begin
			Data_out_0 = 0;
			Data_out_1 = 0;
			Data_out_2 = 0;
		end
	endcase
end

endmodule