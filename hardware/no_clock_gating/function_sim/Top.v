`include "PE.v"
`include "PE_array.v"
`include "RfTemp.v"
`include "Adder.v"
`include "Adder2.v"
`include "psumBuf.v"
`include "convBuf.v"
`include "controller.v"
`include "FIFO.v"
`include "rowRf.v"
`include "rowSelect.v"
`include "FIFO_out.v"

module Top(clk, rst, ifmap, filter, bias, DRAMreadEn, DRAMreadAddr, DRAMwriteEn, DRAMwriteAddr, DRAMwriteData);

input clk, rst;
input [63:0] ifmap;
input [71:0] filter;
input [15:0] bias;

output DRAMreadEn, DRAMwriteEn;
output [9:0] DRAMreadAddr, DRAMwriteAddr;
output [63:0] DRAMwriteData;

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

// rowRf
wire toMem0, toMem1, toMem2, toMem3;
wire [1:0] rowWriteAddress;
wire [63:0] row1Out, row2Out, row3Out, row4Out;
wire fullRow;

// For rowSelect
wire [63:0] ifmaprow1, ifmaprow2, ifmaprow3;
wire [1:0] selectRow;

// For FIFO_out
wire [3:0] FIFO_outCount;
wire [63:0] poolResult;
wire [63:0] maxpoolOut;

controller controller( .clk(clk), 
	                   .rst(rst), 
	                   .canRead(canRead), 
	                   .canWrite(canWrite), 
	                   .psumEn(psumEn), 
	                   .first(first), 
	                   .last(last), 
	                   .headAddress(headAddress), 
	                   .DRAMreadEn(DRAMreadEn),
	                   .DRAMreadAddr(DRAMreadAddr), 
	                   .ReadCount(ReadCount),
	                   .fullRow(fullRow), 
	                   .toMem0(toMem0), 
	                   .toMem1(toMem1), 
	                   .toMem2(toMem2), 
	                   .toMem3(toMem3), 
	                   .selectRow(selectRow) );

FIFO FIFO_0( .clk(clk), 
	         .rst(rst), 
	         .ifmapIn(ifmap), 
	         .canRead(canRead), 
	         .canWrite(canWrite), 
	         .ifmapOut(FIFO_out),
	         .rowWriteAddress(rowWriteAddress), 
	         .ReadCount(ReadCount) ) ;

rowRf rowRf_0( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem0), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row1Out), 
	           .fullRow(fullRow) );

rowRf rowRf_1( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem1), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row2Out), 
	           .fullRow(fullRow) );

rowRf rowRf_2( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem2), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row3Out), 
	           .fullRow(fullRow) );

rowRf rowRf_3( .clk(clk), 
	           .rst(rst), 
	           .writeEn(toMem3), 
	           .writeAddr(rowWriteAddress), 
	           .writeData(FIFO_out), 
	           .rowOut(row4Out), 
	           .fullRow(fullRow) );

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
	                 .filter(filter), 
	                 .bias(bias), 
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
	               .conv(convResult), 
	               .pool(poolResult), 
	               .count(FIFO_outCount) );

FIFO_out FIFO_out_0( .clk(clk), 
	                 .rst(rst), 
	                 .enCounter(FIFO_outCount), 
	                 .maxpoolIn(poolResult), 
	                 .maxpoolOut(DRAMwriteData), 
	                 .maxpoolOutAddr(DRAMwriteAddr), 
	                 .DRAMwriteEn(DRAMwriteEn) );

endmodule