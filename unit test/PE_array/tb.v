`timescale 1ns/10ps
`define cycle 100  

module testfixture();


// Define input / output port
reg clk = 0;
reg rst = 0;

reg [63:0] ifmapIn1, ifmapIn2, ifmapIn3;
reg [71:0] filter;
reg [15:0] bias;
reg [4:0] counter;


// Connect PE array module
PE_array u_PE_array(.clk(clk), .rst(rst), .ifmapIn1(ifmapIn1), .ifmapIn2(ifmapIn2), .ifmapIn3(ifmapIn3), .filter(filter), .bias(bias));


// Generate fsdb file
initial begin
    $fsdbDumpfile("PE_array.fsdb");
    $fsdbDumpvars();
    $fsdbDumpMDA;
end


// Generate clk
always begin #(`cycle/2) clk <= ~clk; end 


// Asynchronous reset
initial begin
	@(posedge clk); #1; rst = 1'b1;
	# (`cycle*1);
	@(posedge clk); #1; rst = 1'b0;
end


// Send test data 
always@(negedge clk)begin
	if(rst)begin
		ifmapIn1 <= 64'd0;
		ifmapIn2 <= 64'd0;
		ifmapIn3 <= 64'd0;
		filter   <= 72'd0;
		bias     <= 16'd0;
		counter  <= 5'd0;
	end
	else begin
		ifmapIn1 <= 64'b00111001_00010011_00000101_00000001_00000000_00000000_00000000_00000000;
		ifmapIn2 <= 64'b00101011_00110001_00111001_00001001_00000001_00000001_00000000_00000000;
		ifmapIn3 <= 64'b00011010_00101101_00111001_00010000_00000000_00000000_00000000_00000000;
		filter   <= 72'b11111001_11101101_00011010_00001101_11110001_11110100_00010000_00001010_11110001;
		bias     <= 16'b00000001_11001011;

		counter <= counter + 1;
		if(counter==10)
			$finish;
	end
end



endmodule