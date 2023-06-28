module rowSelect(select, row1Out, row2Out, row3Out, row4Out, ifmaprow1, ifmaprow2, ifmaprow3);

input [1:0] select;
input [63:0] row1Out, row2Out, row3Out, row4Out;
output reg [63:0] ifmaprow1, ifmaprow2, ifmaprow3;


always@(*)begin
	case(select)   // To select which 3 rows to output from the 4 rows
		0:begin
			ifmaprow1 = row1Out;
			ifmaprow2 = row2Out;
			ifmaprow3 = row3Out;
		end
		1:begin
			ifmaprow1 = row2Out;
			ifmaprow2 = row3Out;
			ifmaprow3 = row4Out;
		end
		2:begin
			ifmaprow1 = row3Out;
			ifmaprow2 = row4Out;
			ifmaprow3 = row1Out;
		end
		3:begin
			ifmaprow1 = row4Out;
			ifmaprow2 = row1Out;
			ifmaprow3 = row2Out;
		end
	endcase
end

endmodule