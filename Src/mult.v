module mult(input [31:0]A,input [31:0]B,output [31:0]out, input red_A, input red_B,overflow,underflow);
wire [47:0] out1;
wire cp,cm,red_m1,red_m2,mo1,ce,ce2,sign;
wire [22:0]mo2;
wire[49:0] M1; 
wire [22:0]M2;
wire [8:0] E1,E2;
//multiplication with sign
xor(sign,A[31],B[31]);
booth_multiplier bm1(M1,{1'b0,red_A,A[22:0]},{1'b0,red_B,B[22:0]});

// lowerbits reduced
assign red_m1=|M1[22:0];
assign red_m2=|M1[23:0];

//based on last bit matissa shifted end of reduced bits selected, and reduced bit is added for rounding off 
assign mo2=M1[47]?M1[46:24]:M1[45:23]; // here shifting done
assign mo1=M1[47]?red_m2:red_m1; // here remaining bits, reduced bit selected
add_sub24 as24({1'b0,mo2},{23'b0,mo1},0,{temp,M2}); // reduced bit added for roundoff

// exponent added
add_sub8 as83(A[30:23],B[30:23],0,E1[7:0],E1[8]);
add_sub8 as85(E1[7:0],8'h81,M1[47],E2[7:0],ce); // if shifting done exponent subtracted (E1[8] removed=E1-128)
assign E2[8]=E1[8]^1^ce;// subtraction continue
assign ce2=E1[8]|ce;// carry

assign underflow=~ce2;
assign out=A?B?{sign,E2[7:0],M2}:0:0;
assign overflow=E2[8]&ce2;
endmodule



module booth_multiplier(output PRODUCT,input A,input B);
  parameter N=25;//16-bit
   reg signed [2*N-1:0] PRODUCT;//32-bit
   wire signed [N-1:0] A, B;//each 16-bit
  
  reg [25:0] temp;
  integer i;
  reg e;
  reg [N-1:0] B1;

  always @(A,B)
  begin
   
    PRODUCT = 32'd0;
    e = 1'b0;
    B1 = -B;
    temp = { A, e };
    for (i=0; i<N; i=i+1)
    begin
      case(temp[1:0])
        2'd2 : PRODUCT[2*N-1:N] = PRODUCT[2*N-1:N] + B1;//lets A=011110=>first two 10, here msb=1 assuming -ve, -B it continues till 0 
        2'd1 : PRODUCT[2*N-1:N] = PRODUCT[2*N-1:N] + B; // if 0 comes +B is added it becomes positive else remains -ve
      endcase
      // for radix 4 consider X2i+1,X2i=> here *2 then X2i,X2i-1 here like prev one
      PRODUCT = PRODUCT >> 1;
      PRODUCT[2*N-1] = PRODUCT[2*N-2];
      temp=temp>>1;
     // e=A[i];        
    end
  end
  
endmodule