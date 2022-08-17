`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2022 15:29:51
// Design Name: 
// Module Name: Alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Alu(input [31:0] in1,input [31:0] in2,input [1:0]func,output[31:0] result,output overflow,output underflow,output exception);
wire [31:0] result1,result2,result3,result4;
reg [31:0] result5;
reg overflow,underflow;
wire underflow1,underflow2,underflow3,underflow4,overflow1,overflow2,overflow3,overflow4;
excep ex0(in1,in2,func,exception);
assign red_A=|in1[30:23]; //=>denormal of A
assign red_B=|in2[30:23]; //=>denormal of B

add_sub as01(in1,in2,0,result1,red_A,red_B,overflow1,underflow1);
add_sub as02(in1,in2,1,result2,red_A,red_B,overflow2,underflow2);
mult m1(in1,in2,result3,red_A,red_B,overflow3,underflow3);
div1 d1(in1,in2,result4,red_A,red_B,overflow4,underflow4);
always@(*)
begin 
case(func)
 2'b00:begin result5=result1;overflow=overflow1;underflow=underflow1; end
 2'b01:begin result5=result2;overflow=overflow2;underflow=underflow2; end
 2'b10:begin result5=result3;overflow=overflow3;underflow=underflow3; end
 2'b11:begin result5=result4;overflow=overflow4;underflow=underflow4; end
endcase
end

//assign result5=(func==2'b0)?result1:(func==2'b01)?result2:(func==2'b10)?result3:result4;
//assign overflow=(func==2'h0)?overflow1:(func==2'h1)?overflow2:(func==2'h2)?overflow3:overflow4;
//assign underflow=(func==2'h0)?underflow1:(func==2'h1)?underflow2:(func==2'h2)?underflow3:underflow4;
assign result=exception?32'hffffffff:underflow?{32'h0}:overflow?{result5[31],31'h7f800000}:result5;


endmodule
