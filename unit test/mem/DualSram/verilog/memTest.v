module memTest(clk, rst, TbIn, TbOut);

input clk, rst;
input [63:0] TbIn;
output reg [63:0] TbOut;



reg sramEnA;   // SRAM enable (0 represent enable), port A for write in our designs
reg sramEnB;   // SRAM enable (0 represent enable), port B for read in our design

reg wEnA;      // Active-low write enable (1 for read, 0 for write)
reg wEnB;      // Active-low write enable (1 for read, 0 for write)

reg [11:0] sramWaddr; // Port A write address
reg [11:0] sramRaddr; // Port B read wddress 


wire [63:0] sramOut;

sram_dp_4096x64 sram1(
	.CLKA(clk),
	.CLKB(clk),
	.CENA(sramEnA),
	.CENB(sramEnB),
	.WENA(wEnA),      // Always write
	.WENB(wEnB),      // Always read
	.AA(sramWaddr),
	.AB(sramRaddr),
	.DA(TbOut),       // Write data to SRAM by DA
	.DB(64'd0),       // Don't write to SRAM by DB

	// Output
	//.QA(),          // Don't Read data from port A
	.QB(sramOut),     // Read data from port B
	.EMAA(3'd0),
	.EMAB(3'd0),
	.EMASA(1'b0),
	.EMASB(1'b0),
	.EMAWA(2'd0),
	.EMAWB(2'd0),
	.BENA(1'b1),
	.BENB(1'b1),
	.STOVA(1'b0),
	.STOVB(1'b0),
	.TENA(1'b1),
	.TENB(1'b1),
	.RET1N(1'b1)
);


reg crState, ntState;
parameter WRITE = 0,
		  RAEDWRITE  = 1;


always@(posedge clk or posedge rst)begin
	if(rst)begin
		TbOut <= 8'd0;
		crState <= WRITE;
		sramWaddr <= 0;
		sramRaddr <= 0;
		sramEnA <= 0;
		wEnA <= 1'b0;
		sramEnB <= 1;
		wEnB <= 1'b1;
	end
	else begin
		crState <= ntState;
		case(crState)
			WRITE:begin
				sramEnA <= 0;
				TbOut <= TbIn;
				sramWaddr <= sramWaddr + 1;
				if(TbIn==8) sramEnB <= 0;
			end
			RAEDWRITE:begin
				sramEnA <= 0;
				TbOut <= TbIn;
				sramWaddr <= sramWaddr + 1;
				sramRaddr <= sramRaddr + 1;
			end
		endcase
	end
end


always@(*)begin
	case(crState)
		WRITE:begin
			ntState = (TbIn==8)? RAEDWRITE : WRITE;
		end
		RAEDWRITE:begin
			ntState = RAEDWRITE;
		end
	endcase
end

endmodule