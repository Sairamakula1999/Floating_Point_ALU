

module add_sub(input[31:0]in1,input[31:0]in2,input cin,output[31:0] out, input red_A, input red_B, output overflow,output underflow);
wire carr,ca,final_E,c2,c3;
wire [7:0] E1,E1_incre,E2,E3,E_comp,E_c;
wire [23:0] M1,M1_comp,M2,M1_c;
wire [31:0] result1,Bbar,A,B; 
wire [22:0] M3;
wire [4:0] E_shift;

make_exp me0(in1,in2,A,B,red_A,red_B);
assign E1=A[31:24];
xor(sign,cin,in1[31],in2[31]);
assign Bbar=B^{32{sign}};

//addition or subtraction with sign
add_sub24 as24({0,A[22:0]},{0^sign,Bbar[22:0]},sign,M1[23:0],carr); 
assign out[31]=~in1[31]&sign&~carr | ~sign&in1[31] | in1[31]&sign&carr;

//both are added sign if carry add
add_sub8 as83(E1,8'h01,0,E1_incre,ca);
assign E2=carr&~sign?E1_incre:E1; 

//both are subtracted sign if no carry invert mantissa as it will be negative 
assign M1_c=M1^24'hffffff;
add_sub24 as28(M1_c,1,0,M1_comp,c2); 
assign M2=~carr&sign?M1_comp:M1;

//normalize
normalise nm1(M2,carr,sign,M3,E_shift);
// after normalization mantissa shifted here exp subtracted if mantissa=0 entire E made high so, E_comp=0
assign E_comp=(E_shift==5'h18)?8'h00:{3'b000,E_shift}^8'hff;
//add_sub8 as1(E_c,1,0,E_comp,c3); noot reqd 
add_sub8 as85(E2,E_comp,1,E3,final_E);

assign underflow=~final_E;
assign overflow=&E1_incre & ~|E_shift;

assign out[30:0]={E3,M3};
endmodule



module add_sub24 (A, B, cin, S,cout);
input [23:0] A, B; input cin;
output [23:0] S; output cout;
wire cout1;
add_sub16 as160(A[15:0],B[15:0],cin,S[15:0],cout1);
add_sub8 as161(A[23:16],B[23:16],cout1,S[23:16],cout);
endmodule

module add_sub16 (A, B, cin, S,cout);
input [15:0] A, B; input cin;
output [15:0] S; output cout;
wire cout1;
add_sub8 as80(A[7:0],B[7:0],cin,S[7:0],cout1);
add_sub8 as81(A[15:8],B[15:8],cout1,S[15:8],cout);
endmodule

module add_sub8(A, B, cin, S,cout);
input [7:0] A, B; input cin;
output [7:0] S; output cout;
wire cout1;
add_sub4 as0(A[3:0],B[3:0],cin,S[3:0],cout1);
add_sub4 as1(A[7:4],B[7:4],cout1,S[7:4],cout);
endmodule

module add_sub4 (A, B, cin, S, cout);
input [3:0] A, B; input cin;
output [3:0] S; output cout;
wire p0, g0, p1, g1, p2, g2, p3, g3;
wire c1, c2, c3;


assign p0 = A[0] ^ B[0], p1 = A[1] ^ B[1],
p2 = A[2] ^ B[2], p3 = A[3] ^ B[3];

assign g0 = A[0] & B[0], g1 = A[1] & B[1],
g2 = A[2] & B[2], g3 = A[3] & B[3];
assign c1 = g0 | (p0 & cin),
c2 = g1 | (p1 & g0) | (p1 & p0 & cin),
c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & cin),
cout = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) |
(p3 & p2 & p1 & p0 & cin);


assign S[0] = p0 ^ cin, 
S[1] = p1 ^ c1,
S[2] = p2 ^ c2,
S[3] = p3 ^ c3;
endmodule