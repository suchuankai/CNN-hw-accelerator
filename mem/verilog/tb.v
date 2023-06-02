`timescale 1ns/10ps
`define cycle 100  

module testfixture();


// Define input / output port
reg clk = 0;
reg rst = 0;
reg [63:0] TbIn;
wire [63:0] TbOut;


// Connect test module
memTest u_memTest(.clk(clk), 
				  .rst(rst),
				  .TbIn(TbIn),
				  .TbOut(TbOut)
				  );


// Generate fsdb file
initial begin
    $fsdbDumpfile("test.fsdb");
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
		TbIn <= 8'd0;
	end
	else begin
		TbIn <= TbIn + 1;
		if(TbIn==73)
			$finish;
	end
end



endmodule