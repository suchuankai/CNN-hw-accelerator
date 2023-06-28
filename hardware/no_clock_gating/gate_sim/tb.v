`timescale 1ns/10ps
`define cycle 100  
`define ifmapPath  "./data/ifmap.dat" 
`define goldenPath "./data/pool.dat" 

module testfixture();


// Define input / output port
reg clk = 0;
reg rst = 0;

// Input
wire readEn, writeEn;
wire [9:0] readAddr, writeAddr;
wire [63:0] writeData;


// Output
reg [63:0] ifmap;      // DRAM output
reg [71:0] filter;     // DRAM output
reg [15:0] bias;       // DRAM output


// Connect PE array module
Top u_Top( .clk(clk), .rst(rst), .ifmap(ifmap), .filter(filter), .bias(bias), 
		   .DRAMreadEn(readEn), .DRAMreadAddr(readAddr), .DRAMwriteEn(writeEn), .DRAMwriteAddr(writeAddr), .DRAMwriteData(writeData) );

// Generate fsdb file
initial begin
    $fsdbDumpfile("PE_array.fsdb");
    $fsdbDumpvars();
    $fsdbDumpMDA;
end

reg [63:0] mem [0:1023];
reg [7:0] golden[195:0];
// Read ifmap as mem
initial begin
	$display("\n------------ Simulation start ------------\n");
	$readmemb(`ifmapPath, mem);
	$readmemb(`goldenPath, golden);
end

// Generate clk
always begin #(`cycle/2) clk <= ~clk; end 


// Asynchronous reset
initial begin
	@(posedge clk); #1; rst = 1'b1;
	# (`cycle*1);
	@(posedge clk); #1; rst = 1'b0;
end


always@(negedge clk)begin
	if(readEn)begin
		ifmap <= mem[readAddr];
	end
end

integer i;
reg [7:0] maxpoolMem [0:195];
reg [7:0] error;
reg [7:0] errorNum=0, passNum=0;

always@(negedge clk)begin
	if(writeEn)begin
		maxpoolMem[(writeAddr<<3)]   <= writeData[7:0]  ;
		maxpoolMem[(writeAddr<<3)+1] <= writeData[15:8] ;
		maxpoolMem[(writeAddr<<3)+2] <= writeData[23:16];
		maxpoolMem[(writeAddr<<3)+3] <= writeData[31:24];
		maxpoolMem[(writeAddr<<3)+4] <= writeData[39:32];
		maxpoolMem[(writeAddr<<3)+5] <= writeData[47:40];
		maxpoolMem[(writeAddr<<3)+6] <= writeData[55:48];
		maxpoolMem[(writeAddr<<3)+7] <= writeData[63:56];
	end
	if(writeAddr==25) begin

		for(i=0; i<196; i=i+1)begin

			
			if(maxpoolMem[i]>golden[i])
				error = maxpoolMem[i] - golden[i];
			else 
				error = golden[i] - maxpoolMem[i];

			if(error<=1) begin
				passNum = passNum + 1;
				$display("Pixel %3d golden is %3d, get %3d", i, golden[i], maxpoolMem[i]);
			end
			else begin
				errorNum = errorNum + 1;
				$display("Pixel %3d golden is %3d, get %3d , error is %3d", i, golden[i], maxpoolMem[i], error);
			end
		end

		if(errorNum==0)begin
			$display("\n");
			$display("----------------------------------------------------");
			$display("      Congratulations!!! You past all patterns!     ");
			$display("---------------Total use %1d cycles-----------------" ,cycleCount);
			$display("----------------------------------------------------");
		end
		else begin
			$display("\n");
			$display("----------------------------------------------------");
			$display("      There are %1d error in test patterns.", errorNum);
			$display("            Please check your design!!!"             );
			$display("----------------------------------------------------");
		end
		$finish;
	end
end


integer cycleCount=0;
always@(negedge clk)begin
	if(rst)begin
		filter  <= 72'd0;
		bias <= 16'd0;
	end
	else begin
		cycleCount <= cycleCount +1;
		filter   <= 72'b11111001_11101101_00011010_00001101_11110001_11110100_00010000_00001010_11110001;
		bias     <= 16'b00000001_11001011;
	end
end

endmodule