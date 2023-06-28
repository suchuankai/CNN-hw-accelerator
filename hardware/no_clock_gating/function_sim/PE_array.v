module PE_array(clk, rst, ifmapIn1, ifmapIn2, ifmapIn3, filter, bias, toPsum);

input clk, rst;
input [63:0] ifmapIn1, ifmapIn2, ifmapIn3;
input [71:0] filter;
input [15:0] bias;

output [175:0] toPsum;
wire [21:0] toPsumBuf[10:1];

assign toPsum = { toPsumBuf[10], toPsumBuf[9], toPsumBuf[8], toPsumBuf[7], toPsumBuf[6], 
				  toPsumBuf[5] , toPsumBuf[4], toPsumBuf[3], toPsumBuf[2], toPsumBuf[1] };

/*
			     PE1   PE2   PE3   PE4   PE5   PE6   PE7   PE8
		   PE9   PE10  PE11  PE12  PE13  PE14  PE15  PE16 
	 PE17  PE18  PE19  PE20  PE21  PE22  PE23  PE24 

 			     PE25  PE26  PE27  PE28  PE29  PE30  PE31  PE32
	   	   PE33  PE34  PE35  PE36  PE37  PE38  PE39  PE40 
     PE41  PE42  PE43  PE44  PE45  PE46  PE47  PE48 

 			     PE49  PE50  PE51  PE52  PE53  PE54  PE55  PE56
	       PE57  PE58  PE59  PE60  PE61  PE62  PE63  PE64 
     PE65  PE66  PE67  PE68  PE69  PE70  PE71  PE72 
*/


wire [19:0] pout1,  pout2,  pout3,  pout4,  pout5,  pout6,  pout7,  pout8;
wire [19:0] pout9,  pout10, pout11, pout12, pout13, pout14, pout15, pout16;
wire [19:0] pout17, pout18, pout19, pout20, pout21, pout22, pout23, pout24;
wire [19:0] pout25, pout26, pout27, pout28, pout29, pout30, pout31, pout32;
wire [19:0] pout33, pout34, pout35, pout36, pout37, pout38, pout39, pout40;
wire [19:0] pout41, pout42, pout43, pout44, pout45, pout46, pout47, pout48;
wire [19:0] pout49, pout50, pout51, pout52, pout53, pout54, pout55, pout56;
wire [19:0] pout57, pout58, pout59, pout60, pout61, pout62, pout63, pout64;
wire [19:0] pout65, pout66, pout67, pout68, pout69, pout70, pout71, pout72;


/* ---------------------------------------- Row1 ---------------------------------------- */

wire [19:0] RF1out[10:1];
RfTemp Rf1( .clk(clk), .rst(rst),
	        .In1(pout17), .In2(pout9), .In3(pout1), .In4(pout2), .In5(pout3), .In6(pout4), .In7(pout5), .In8(pout6), .In9(pout7), .In10(pout8),
	        .Out1(RF1out[1]), .Out2(RF1out[2]), .Out3(RF1out[3]), .Out4(RF1out[4]), .Out5(RF1out[5]), .Out6(RF1out[6]), .Out7(RF1out[7]), .Out8(RF1out[8]), .Out9(RF1out[9]), .Out10(RF1out[10]) );

PE PE1( .clk(clk), .rst(rst), .ifmap(ifmapIn1[7:0]  ), .filter(filter[7:0]), .psumIn(pout10), .psumOut(pout1) );
PE PE2( .clk(clk), .rst(rst), .ifmap(ifmapIn1[15:8] ), .filter(filter[7:0]), .psumIn(pout11), .psumOut(pout2) );
PE PE3( .clk(clk), .rst(rst), .ifmap(ifmapIn1[23:16]), .filter(filter[7:0]), .psumIn(pout12), .psumOut(pout3) );
PE PE4( .clk(clk), .rst(rst), .ifmap(ifmapIn1[31:24]), .filter(filter[7:0]), .psumIn(pout13), .psumOut(pout4) );
PE PE5( .clk(clk), .rst(rst), .ifmap(ifmapIn1[39:32]), .filter(filter[7:0]), .psumIn(pout14), .psumOut(pout5) );
PE PE6( .clk(clk), .rst(rst), .ifmap(ifmapIn1[47:40]), .filter(filter[7:0]), .psumIn(pout15), .psumOut(pout6) );
PE PE7( .clk(clk), .rst(rst), .ifmap(ifmapIn1[55:48]), .filter(filter[7:0]), .psumIn(pout16), .psumOut(pout7) );
PE PE8( .clk(clk), .rst(rst), .ifmap(ifmapIn1[63:56]), .filter(filter[7:0]), .psumIn(20'd0), .psumOut(pout8) );

PE PE9 ( .clk(clk), .rst(rst), .ifmap(ifmapIn1[7:0]  ), .filter(filter[15:8]), .psumIn(pout18), .psumOut(pout9)  );
PE PE10( .clk(clk), .rst(rst), .ifmap(ifmapIn1[15:8] ), .filter(filter[15:8]), .psumIn(pout19), .psumOut(pout10) );
PE PE11( .clk(clk), .rst(rst), .ifmap(ifmapIn1[23:16]), .filter(filter[15:8]), .psumIn(pout20), .psumOut(pout11) );
PE PE12( .clk(clk), .rst(rst), .ifmap(ifmapIn1[31:24]), .filter(filter[15:8]), .psumIn(pout21), .psumOut(pout12) );
PE PE13( .clk(clk), .rst(rst), .ifmap(ifmapIn1[39:32]), .filter(filter[15:8]), .psumIn(pout22), .psumOut(pout13) );
PE PE14( .clk(clk), .rst(rst), .ifmap(ifmapIn1[47:40]), .filter(filter[15:8]), .psumIn(pout23), .psumOut(pout14) );
PE PE15( .clk(clk), .rst(rst), .ifmap(ifmapIn1[55:48]), .filter(filter[15:8]), .psumIn(pout24), .psumOut(pout15) );
PE PE16( .clk(clk), .rst(rst), .ifmap(ifmapIn1[63:56]), .filter(filter[15:8]), .psumIn(20'd0), .psumOut(pout16) );

PE PE17( .clk(clk), .rst(rst), .ifmap(ifmapIn1[7:0]  ), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout17) );
PE PE18( .clk(clk), .rst(rst), .ifmap(ifmapIn1[15:8] ), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout18) );
PE PE19( .clk(clk), .rst(rst), .ifmap(ifmapIn1[23:16]), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout19) );
PE PE20( .clk(clk), .rst(rst), .ifmap(ifmapIn1[31:24]), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout20) );
PE PE21( .clk(clk), .rst(rst), .ifmap(ifmapIn1[39:32]), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout21) );
PE PE22( .clk(clk), .rst(rst), .ifmap(ifmapIn1[47:40]), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout22) );
PE PE23( .clk(clk), .rst(rst), .ifmap(ifmapIn1[55:48]), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout23) );
PE PE24( .clk(clk), .rst(rst), .ifmap(ifmapIn1[63:56]), .filter(filter[23:16]), .psumIn(20'd0), .psumOut(pout24) );


/* ---------------------------------------- Row2 ---------------------------------------- */

wire [19:0] RF2out[10:1];
RfTemp Rf2( .clk(clk), .rst(rst),
	        .In1(pout41), .In2(pout33), .In3(pout25), .In4(pout26), .In5(pout27), .In6(pout28), .In7(pout29), .In8(pout30), .In9(pout31), .In10(pout32),
	        .Out1(RF2out[1]), .Out2(RF2out[2]), .Out3(RF2out[3]), .Out4(RF2out[4]), .Out5(RF2out[5]), .Out6(RF2out[6]), .Out7(RF2out[7]), .Out8(RF2out[8]), .Out9(RF2out[9]), .Out10(RF2out[10]) );

PE PE25( .clk(clk), .rst(rst), .ifmap(ifmapIn2[7:0]  ), .filter(filter[31:24]), .psumIn(pout34), .psumOut(pout25) );
PE PE26( .clk(clk), .rst(rst), .ifmap(ifmapIn2[15:8] ), .filter(filter[31:24]), .psumIn(pout35), .psumOut(pout26) );
PE PE27( .clk(clk), .rst(rst), .ifmap(ifmapIn2[23:16]), .filter(filter[31:24]), .psumIn(pout36), .psumOut(pout27) );
PE PE28( .clk(clk), .rst(rst), .ifmap(ifmapIn2[31:24]), .filter(filter[31:24]), .psumIn(pout37), .psumOut(pout28) );
PE PE29( .clk(clk), .rst(rst), .ifmap(ifmapIn2[39:32]), .filter(filter[31:24]), .psumIn(pout38), .psumOut(pout29) );
PE PE30( .clk(clk), .rst(rst), .ifmap(ifmapIn2[47:40]), .filter(filter[31:24]), .psumIn(pout39), .psumOut(pout30) );
PE PE31( .clk(clk), .rst(rst), .ifmap(ifmapIn2[55:48]), .filter(filter[31:24]), .psumIn(pout40), .psumOut(pout31) );
PE PE32( .clk(clk), .rst(rst), .ifmap(ifmapIn2[63:56]), .filter(filter[31:24]), .psumIn(20'd0), .psumOut(pout32) );

PE PE33( .clk(clk), .rst(rst), .ifmap(ifmapIn2[7:0]  ), .filter(filter[39:32]), .psumIn(pout42), .psumOut(pout33) );
PE PE34( .clk(clk), .rst(rst), .ifmap(ifmapIn2[15:8] ), .filter(filter[39:32]), .psumIn(pout43), .psumOut(pout34) );
PE PE35( .clk(clk), .rst(rst), .ifmap(ifmapIn2[23:16]), .filter(filter[39:32]), .psumIn(pout44), .psumOut(pout35) );
PE PE36( .clk(clk), .rst(rst), .ifmap(ifmapIn2[31:24]), .filter(filter[39:32]), .psumIn(pout45), .psumOut(pout36) );
PE PE37( .clk(clk), .rst(rst), .ifmap(ifmapIn2[39:32]), .filter(filter[39:32]), .psumIn(pout46), .psumOut(pout37) );
PE PE38( .clk(clk), .rst(rst), .ifmap(ifmapIn2[47:40]), .filter(filter[39:32]), .psumIn(pout47), .psumOut(pout38) );
PE PE39( .clk(clk), .rst(rst), .ifmap(ifmapIn2[55:48]), .filter(filter[39:32]), .psumIn(pout48), .psumOut(pout39) );
PE PE40( .clk(clk), .rst(rst), .ifmap(ifmapIn2[63:56]), .filter(filter[39:32]), .psumIn(20'd0), .psumOut(pout40) );

PE PE41( .clk(clk), .rst(rst), .ifmap(ifmapIn2[7:0]  ), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout41) );
PE PE42( .clk(clk), .rst(rst), .ifmap(ifmapIn2[15:8] ), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout42) );
PE PE43( .clk(clk), .rst(rst), .ifmap(ifmapIn2[23:16]), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout43) );
PE PE44( .clk(clk), .rst(rst), .ifmap(ifmapIn2[31:24]), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout44) );
PE PE45( .clk(clk), .rst(rst), .ifmap(ifmapIn2[39:32]), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout45) );
PE PE46( .clk(clk), .rst(rst), .ifmap(ifmapIn2[47:40]), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout46) );
PE PE47( .clk(clk), .rst(rst), .ifmap(ifmapIn2[55:48]), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout47) );
PE PE48( .clk(clk), .rst(rst), .ifmap(ifmapIn2[63:56]), .filter(filter[47:40]), .psumIn(20'd0), .psumOut(pout48) );


/* ---------------------------------------- Row3 ---------------------------------------- */

wire [19:0] RF3out[10:1];
RfTemp Rf3( .clk(clk), .rst(rst),
	        .In1(pout65), .In2(pout57), .In3(pout49), .In4(pout50), .In5(pout51), .In6(pout52), .In7(pout53), .In8(pout54), .In9(pout55), .In10(pout56),
	        .Out1(RF3out[1]), .Out2(RF3out[2]), .Out3(RF3out[3]), .Out4(RF3out[4]), .Out5(RF3out[5]), .Out6(RF3out[6]), .Out7(RF3out[7]), .Out8(RF3out[8]), .Out9(RF3out[9]), .Out10(RF3out[10]) );

PE PE49( .clk(clk), .rst(rst), .ifmap(ifmapIn3[7:0]  ), .filter(filter[55:48]), .psumIn(pout58), .psumOut(pout49) );
PE PE50( .clk(clk), .rst(rst), .ifmap(ifmapIn3[15:8] ), .filter(filter[55:48]), .psumIn(pout59), .psumOut(pout50) );
PE PE51( .clk(clk), .rst(rst), .ifmap(ifmapIn3[23:16]), .filter(filter[55:48]), .psumIn(pout60), .psumOut(pout51) );
PE PE52( .clk(clk), .rst(rst), .ifmap(ifmapIn3[31:24]), .filter(filter[55:48]), .psumIn(pout61), .psumOut(pout52) );
PE PE53( .clk(clk), .rst(rst), .ifmap(ifmapIn3[39:32]), .filter(filter[55:48]), .psumIn(pout62), .psumOut(pout53) );
PE PE54( .clk(clk), .rst(rst), .ifmap(ifmapIn3[47:40]), .filter(filter[55:48]), .psumIn(pout63), .psumOut(pout54) );
PE PE55( .clk(clk), .rst(rst), .ifmap(ifmapIn3[55:48]), .filter(filter[55:48]), .psumIn(pout64), .psumOut(pout55) );
PE PE56( .clk(clk), .rst(rst), .ifmap(ifmapIn3[63:56]), .filter(filter[55:48]), .psumIn(20'd0), .psumOut(pout56) );

PE PE57( .clk(clk), .rst(rst), .ifmap(ifmapIn3[7:0]  ), .filter(filter[63:56]), .psumIn(pout66), .psumOut(pout57) );
PE PE58( .clk(clk), .rst(rst), .ifmap(ifmapIn3[15:8] ), .filter(filter[63:56]), .psumIn(pout67), .psumOut(pout58) );
PE PE59( .clk(clk), .rst(rst), .ifmap(ifmapIn3[23:16]), .filter(filter[63:56]), .psumIn(pout68), .psumOut(pout59) );
PE PE60( .clk(clk), .rst(rst), .ifmap(ifmapIn3[31:24]), .filter(filter[63:56]), .psumIn(pout69), .psumOut(pout60) );
PE PE61( .clk(clk), .rst(rst), .ifmap(ifmapIn3[39:32]), .filter(filter[63:56]), .psumIn(pout70), .psumOut(pout61) );
PE PE62( .clk(clk), .rst(rst), .ifmap(ifmapIn3[47:40]), .filter(filter[63:56]), .psumIn(pout71), .psumOut(pout62) );
PE PE63( .clk(clk), .rst(rst), .ifmap(ifmapIn3[55:48]), .filter(filter[63:56]), .psumIn(pout72), .psumOut(pout63) );
PE PE64( .clk(clk), .rst(rst), .ifmap(ifmapIn3[63:56]), .filter(filter[63:56]), .psumIn(20'd0), .psumOut(pout64) );

PE PE65( .clk(clk), .rst(rst), .ifmap(ifmapIn3[7:0]  ), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout65) );
PE PE66( .clk(clk), .rst(rst), .ifmap(ifmapIn3[15:8] ), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout66) );
PE PE67( .clk(clk), .rst(rst), .ifmap(ifmapIn3[23:16]), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout67) );
PE PE68( .clk(clk), .rst(rst), .ifmap(ifmapIn3[31:24]), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout68) );
PE PE69( .clk(clk), .rst(rst), .ifmap(ifmapIn3[39:32]), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout69) );
PE PE70( .clk(clk), .rst(rst), .ifmap(ifmapIn3[47:40]), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout70) );
PE PE71( .clk(clk), .rst(rst), .ifmap(ifmapIn3[55:48]), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout71) );
PE PE72( .clk(clk), .rst(rst), .ifmap(ifmapIn3[63:56]), .filter(filter[71:64]), .psumIn({4'd0, bias}), .psumOut(pout72) );


Adder2 Adder2_1 (.clk(clk), .rst(rst), .Rf1_sum(RF1out[1]), .Rf2_sum(RF2out[1]), .Rf3_sum(RF3out[1]), .psum(toPsumBuf[9][19:0]),  .toPsumBuf(toPsumBuf[1]));
Adder2 Adder2_2 (.clk(clk), .rst(rst), .Rf1_sum(RF1out[2]), .Rf2_sum(RF2out[2]), .Rf3_sum(RF3out[2]), .psum(toPsumBuf[10][19:0]), .toPsumBuf(toPsumBuf[2]));
Adder  Adder3   (.clk(clk), .rst(rst), .Rf1_sum(RF1out[3]), .Rf2_sum(RF2out[3]), .Rf3_sum(RF3out[3]), .toPsumBuf(toPsumBuf[3]));
Adder  Adder4   (.clk(clk), .rst(rst), .Rf1_sum(RF1out[4]), .Rf2_sum(RF2out[4]), .Rf3_sum(RF3out[4]), .toPsumBuf(toPsumBuf[4]));
Adder  Adder5   (.clk(clk), .rst(rst), .Rf1_sum(RF1out[5]), .Rf2_sum(RF2out[5]), .Rf3_sum(RF3out[5]), .toPsumBuf(toPsumBuf[5]));
Adder  Adder6   (.clk(clk), .rst(rst), .Rf1_sum(RF1out[6]), .Rf2_sum(RF2out[6]), .Rf3_sum(RF3out[6]), .toPsumBuf(toPsumBuf[6]));
Adder  Adder7   (.clk(clk), .rst(rst), .Rf1_sum(RF1out[7]), .Rf2_sum(RF2out[7]), .Rf3_sum(RF3out[7]), .toPsumBuf(toPsumBuf[7]));
Adder  Adder8   (.clk(clk), .rst(rst), .Rf1_sum(RF1out[8]), .Rf2_sum(RF2out[8]), .Rf3_sum(RF3out[8]), .toPsumBuf(toPsumBuf[8]));
Adder  Adder9   (.clk(clk), .rst(rst), .Rf1_sum(RF1out[9]), .Rf2_sum(RF2out[9]), .Rf3_sum(RF3out[9]), .toPsumBuf(toPsumBuf[9]));
Adder  Adder10  (.clk(clk), .rst(rst), .Rf1_sum(RF1out[10]),.Rf2_sum(RF2out[10]),.Rf3_sum(RF3out[10]),.toPsumBuf(toPsumBuf[10]));

endmodule