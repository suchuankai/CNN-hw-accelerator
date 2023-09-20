`timescale 1ns/10ps
`define cycle 10 
`define ifmapPath  "./data/ifmap.dat" 
`define goldenPath "./data/final.dat" 
`define SDFFILE    "./Top_syn.sdf"	  // Modify your sdf file name
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
Top u_Top( .clk(clk), .rst(rst), .ifmap(ifmap), 
		   .DRAMreadEn(readEn), .DRAMreadAddr(readAddr), .DRAMwriteEn(writeEn), .DRAMwriteAddr(writeAddr), .DRAMwriteData(writeData) );

// Generate fsdb file
initial begin
    $fsdbDumpfile("Top.fsdb");
    $fsdbDumpvars();
    $fsdbDumpMDA;
end

`ifdef SDF
	initial $sdf_annotate(`SDFFILE, u_Top);
`endif

reg [63:0] mem   [0:1023];
reg [63:0] golden[0:150];
// Read ifmap as mem
initial begin
	$display("\n------------ Simulation start ------------\n");
	// 0~1 : bias, 2~8 : kernel, 9~121 : ifmap
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

integer i, j;
reg [10:0] error;
reg [10:0] errorNum=0, passNum=0;

always@(negedge clk)begin
	if(writeEn)begin
		mem[writeAddr] <= writeData;
	end
	if(writeAddr==160+238) begin  //150

		for(i=238; i<150+238; i=i+1)begin  // Compare eight data in one row

			for(j=0; j<8; j=j+1)begin

				if(mem[i][7+8*j -: 8]>golden[i-238][7+8*j -: 8])
					error = mem[i][7+8*j -: 8] - golden[i-238][7+8*j -: 8];
				else 
					error = golden[i-238][7+8*j -: 8] - mem[i][7+8*j -: 8];

				if(error<=2) begin
					passNum = passNum + 1;
					$display("Pixel %3d golden is %3d, get %3d", 8*(i-238)+j, golden[i-238][7+8*j -: 8], mem[i][7+8*j -: 8]);
				end
				else begin
					errorNum = errorNum + 1;
					$display("Pixel %3d golden is %3d, get %3d , error is %3d", 8*(i-238)+j, golden[i-238][7+8*j -: 8], mem[i][7+8*j -: 8], error);
				end
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
			$display("---------------Total use %1d cycles-----------------" ,cycleCount);
			$display("      There are %1d error in test patterns.", errorNum);
			$display("            Please check your design!!!"             );
			$display("----------------------------------------------------");
		end
		$finish;
	end
end


integer cycleCount=0;
reg mode;
always@(negedge clk)begin
	if(rst)begin
		filter  <= 72'd0;
		bias <= 16'd0;
		mode <= 0;
	end
	else begin
		cycleCount <= cycleCount +1;
	end
end


endmodule