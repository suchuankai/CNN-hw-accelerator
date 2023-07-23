`include "define.vh"

module Top(clk, rst, ifmap, filter, bias, DRAMreadEn, DRAMreadAddr, DRAMwriteEn, DRAMwriteAddr, DRAMwriteData);

input clk, rst;
input [63:0] ifmap;
input [71:0] filter;
input [15:0] bias;

output DRAMreadEn, DRAMwriteEn;
output [9:0] DRAMreadAddr, DRAMwriteAddr;
output [63:0] DRAMwriteData;

// For tb
wire [1:0] inSel;
wire [63:0] Data_out_0, Data_out_1, Data_out_2;

// For biasBuf
wire biasBufEn;
wire [15:0] bias_out;
wire [2:0] biasBuf_in_addr;
wire [2:0] bias_weight_outAddr;

// For weightBuf
wire [71:0] weightBufOut;

// PE array / psum
wire [175:0] toPsum ;
wire psumEn, first, last;
wire [5:0] headAddress;

// Conv Buf
wire convValid;
wire [31:0] convResult;

// FIFO
wire canRead, canWrite;
wire [63:0] FIFO_out;
wire [4:0] ReadCount;
wire needRead;
wire clear;
wire FIFO_En;
wire [10:0] totalRead; 

// For FIFO_w_0
wire [71:0] weightOut;
wire [2:0] weightAddr;
wire [4:0] weightCount;
wire FIFO_w_En;
wire FIFO_w_canWrite;
wire FIFO_w_canRead;

// rowRf
wire toMem0, toMem1, toMem2, toMem3;
wire [1:0] rowWriteAddress;
wire [63:0] row1Out, row2Out, row3Out, row4Out;
wire fullRow;
wire threeRowready;

// For rowSelect
wire [63:0] ifmaprow1, ifmaprow2, ifmaprow3;
wire [1:0] selectRow;

// For FIFO_out
wire [3:0] FIFO_outCount;
wire [63:0] poolResult;
wire [63:0] maxpoolOut;


demux1_3 demux1_3_0(.Data_in(ifmap), 
	                .sel(inSel), 
	                .Data_out_0(Data_out_0), 
	                .Data_out_1(Data_out_1), 
	                .Data_out_2(Data_out_2) );

biasBuf biasBuf_0( .clk(clk),
	               .rst(rst),
	               .readen(biasBufEn),  
	               .in_index(biasBuf_in_addr), 
	               .out_index(bias_weight_outAddr), 
	               .datain(Data_out_0), 
	               .dataout(bias_out) );


controller controller( .clk(clk), 
	                   .rst(rst), 
	                   .inSel(inSel),
	                   .biasBuf_in_addr(biasBuf_in_addr),
	                   .bias_weight_outAddr(bias_weight_outAddr),
	                   .biasBufEn(biasBufEn), 
	                   .FIFO_w_canWrite(FIFO_w_canWrite),
	                   .FIFO_w_canRead(FIFO_w_canRead),
	                   .FIFO_w_En(FIFO_w_En),
	                   .canRead(canRead), 
	                   .canWrite(canWrite), 
	                   .psumEn(psumEn), 
	                   .first(first), 
	                   .last(last), 
	                   .headAddress(headAddress), 
	                   .DRAMreadEn(DRAMreadEn),
	                   .DRAMreadAddr(DRAMreadAddr),
	                   .needRead(needRead), 
	                   .clear(clear), 
	                   .FIFO_En(FIFO_En),
	                   .ReadCount(ReadCount),
	                   .FIFOtotalRead(totalRead),
	                   .fullRow(fullRow),
	                   .threeRowready(threeRowready), 
	                   .toMem0(toMem0), 
	                   .toMem1(toMem1), 
	                   .toMem2(toMem2), 
	                   .toMem3(toMem3), 
	                   .selectRow(selectRow) );

FIFO FIFO_0( .clk(clk), 
	         .rst(rst), 
	         .ifmapIn(Data_out_2),
	         .clear(clear), 
	         .canRead(canRead),
	         .needRead(needRead), 
	         .FIFO_En(FIFO_En),
	         .canWrite(canWrite), 
	         .ifmapOut(FIFO_out),
	         .rowWriteAddress(rowWriteAddress), 
	         .ReadCount(ReadCount),
	         .totalRead(totalRead) ) ;

FIFO_w FIFO_w_0( .clk(clk), 
	             .rst(rst),
	             .FIFO_w_En(FIFO_w_En), 
	             .canWrite(FIFO_w_canWrite),
	             .canRead(FIFO_w_canRead),
	             .ifmapIn(Data_out_1), 
	             .ifmapOut(weightOut), 
	             .weightAddr(weightAddr), 
	             .ReadCount(weightCount) );

weightBuf weightBuf_0( .clk(clk), 
	                   .rst(rst), 
	                   .readen(1'b1), 
	                   .in_index(weightAddr), 
	                   .out_index(bias_weight_outAddr), 
	                   .datain(weightOut), 
	                   .dataout(weightBufOut) );

rowRf rowRf_0( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem0), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row1Out), 
	           .fullRow(fullRow), 
	           .threeRowready(threeRowready));

rowRf rowRf_1( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem1), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row2Out), 
	           .fullRow(fullRow), 
	           .threeRowready(threeRowready));

rowRf rowRf_2( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem2), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row3Out), 
	           .fullRow(fullRow), 
	           .threeRowready(threeRowready));

rowRf rowRf_3( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem3), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row4Out), 
	           .fullRow(fullRow), 
	           .threeRowready(threeRowready));

rowSelect rowSelect_0( .select(selectRow), 
	                   .row1Out(row1Out), 
	                   .row2Out(row2Out), 
	                   .row3Out(row3Out), 
	                   .row4Out(row4Out), 
	                   .ifmaprow1(ifmaprow1), 
	                   .ifmaprow2(ifmaprow2), 
	                   .ifmaprow3(ifmaprow3) );

PE_array PE_array_0( .clk(clk), 
	                 .rst(rst), 
	                 .ifmapIn1(ifmaprow1), 
	                 .ifmapIn2(ifmaprow2), 
	                 .ifmapIn3(ifmaprow3), 
	                 .filter(weightBufOut), 
	                 .bias(bias_out), 
	                 .toPsum(toPsum) );

psumBuf psumBuf_0( .clk(clk), 
	               .rst(rst), 
	               .enable(psumEn), 
	               .first(first), 
	               .last(last), 
	               .psumIn(toPsum), 
	               .headAddress(headAddress), 
	               .convValid(convValid), 
	               .convResult(convResult) );

convBuf convBuf_0( .clk(clk), 
	               .rst(rst), 
	               .valid(convValid),
	               .clear(clear), 
	               .conv(convResult), 
	               .pool(poolResult), 
	               .count(FIFO_outCount) );

FIFO_out FIFO_out_0( .clk(clk), 
	                 .rst(rst), 
	                 .clear(clear),
	                 .enCounter(FIFO_outCount), 
	                 .maxpoolIn(poolResult), 
	                 .maxpoolOut(DRAMwriteData), 
	                 .maxpoolOutAddr(DRAMwriteAddr), 
	                 .DRAMwriteEn(DRAMwriteEn) );

endmodule