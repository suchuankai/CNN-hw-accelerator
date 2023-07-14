module convBuf(clk, rst, valid, conv, pool, count);
input clk, rst;
input valid;
input [31:0] conv;
output reg [63:0] pool;
output reg [3:0] count;

reg [127:0] conv_buffer;

wire [7:0] max[0:3];
assign max[0] = (conv[7:0]   > conv_buffer[7:0]  ) ? conv[7:0]   : conv_buffer[7:0]  ;
assign max[1] = (conv[15:8]  > conv_buffer[15:8] ) ? conv[15:8]  : conv_buffer[15:8] ;
assign max[2] = (conv[23:16] > conv_buffer[23:16]) ? conv[23:16] : conv_buffer[23:16];
assign max[3] = (conv[31:24] > conv_buffer[31:24]) ? conv[31:24] : conv_buffer[31:24];

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        count <= 4'd0;
        pool <= 64'd0;
        conv_buffer <= 128'd0;
    end
    else begin
        if(valid) begin
            count <= count + 1;
            conv_buffer <= {conv, conv_buffer[127:32]};
            if(count >= 4) begin
                pool <= {max[3], max[2], max[1], max[0], pool[63:32]};
            end
        end
        else if(count==8)
            count <= 0;  
    end
end

endmodule
