`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2022 16:55:47
// Design Name: 
// Module Name: div1
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


module div1(input [31:0] A,input [31:0] B,output [31:0] out,input  red_A, input red_B,output overflow,output underflow);
wire sign;
wire [24:0]M1;
wire [22:0]M2;
wire [7:0]E1,E2;
//wire [31:0]Bbar;
//wire [23:0]Osub;
//wire ocarr,ca;
assign Bbar=B^32'hffffffff;

//
//add_sub24 as25({red_A,A[22:0]},{red_B^1,Bbar[22:0]},1,Osub[23:0],ocarr);

wire [23:0]A2,B2;
//wire [7:0]E1_A,E1_sub;
////division overflow
//assign A2=ocarr?{red_A,A[22:0]}>>1:{red_A,A[22:0]}; 
//assign B2={red_B,B[22:0]};
//add_sub8 as82(A[30:23],ocarr,0,E1_A,ca);
assign A2={red_A,A[22:0]};
assign B2={red_B,B[22:0]};
//division4
xor(sign,A[31],B[31]);
division1 dv1({1'b0,A2},{1'b0,B2},M1);
//add_sub8 as83(E1_A,Bbar[30:23],1,E1_sub,ca);
//add_sub8 as81(E1_sub,8'h7f,0,E2,ca);


//assign red_m1=|M1[22:0];
//assign mo1=M1[46:24];

// exponent subtracted
wire k,ksum,kcarr;
add_sub8 as84(A[30:23],B[30:23]^8'hff,M1[24],E1[7:0],k);
//assign E1[8]=~k;
add_sub8 as85(E1[7:0],8'h7f,0,E2[7:0],ce); // if shifting done exponent subtracted
//assign E2[8]=E1[8]^0^ce;
//assign kcarr=E1[8]&ce;
//add_sub24 as24({1'b0,mo2},{23'b0,mo1},0,{temp,M2});
assign M2=M1[24]?M1[23:1]:M1[22:0];
assign out=A?{sign,E2,M2}:0;    
assign underflow=~k&~ce;
assign overflow=k&ce;
endmodule


module division1(dividend, divisor, result);

input [24:0] divisor, dividend;
output reg [24:0] result;

// Variables
integer i;
reg [24:0] dividend_copy;// added one for sign and another for reduced exponent
reg [24:0] divisor_copy;
reg [24:0] temp;
reg sign; 

always @(divisor or dividend)
begin
	//sign= dividend[7]^divisor[7];
	divisor_copy = divisor;

	dividend_copy = {25'b0};
	//temp = {25{dividend[24]}}; 
	temp =dividend; //since always positive
	for(i = 0;i < 25;i = i + 1)
	begin
	     
		
		/*
			* Substract the Divisor Register from the Remainder Register and
			* plave the result in remainder register (temp variable here!)
		*/
		temp = i?{temp[23:0], dividend_copy[24]}:temp;//avoid shift for 1st run
		//  #1;
		dividend_copy[24:1] = dividend_copy[23:0];
		temp=temp-divisor_copy;
		// Compare the Sign of Remainder Register (temp)
		if(temp[24] == ~dividend[24])
		begin
		/*
			* Restore original value by adding the Divisor Register to the
			* Remainder Register and placing the sum in Remainder Register.
			* Shift Quatient by 1 and Add 0 to last bit.
		*/
			dividend_copy[0] = 0;
			temp = temp + divisor_copy;
		end
		else
		begin
		/*
			* Shift Quatient to left.
			* Set right most bit to 1.
		*/
			dividend_copy[0] = 1;
		end
		
	end
	result = dividend_copy;
	//remainder = temp;
end
endmodule
