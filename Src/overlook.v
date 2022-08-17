module make_exp( input [31:0]in1,input [31:0]in2,output [31:0]A,output[31:0] B,input red_A,input red_B);
wire [7:0] E1,E2,E2bar,diff_E,diff_E2,final_E,diff_E_comp,diff_E_c;
wire [23:0] M1,M2,cee;
wire ce,E1_big;
assign E1=in1[30:23];
assign E2=in2[30:23];
assign ce=1'b1;
assign E2bar=E2^{32{ce}};
add_sub8 as0(E1,E2bar,ce,diff_E,E1_big);

assign diff_E_c=diff_E^8'hff;
add_sub8 as1(diff_E_c,1,0,diff_E_comp,cee);

assign diff_E2=E1_big?diff_E:diff_E_comp;
assign final_E=E1_big?E1:E2;
assign M1=E1_big?{red_A,in1[22:0]}:{red_A,in1[22:0]}>>diff_E2;
assign M2=E1_big?{red_B,in2[22:0]}>>diff_E2:{red_B,in2[22:0]};
assign A={final_E,M1};
assign B={final_E,M2};

endmodule


module excep( input [31:0]in1,input [31:0]in2,input [1:0] func,output exception);
wire ex1,ex2,ex3;
assign ex1=&in1[31:23];
assign ex2=&in2[31:23];
assign ex3=(~|in2[31:23]) & (&func[1:0]);

assign exception= ex1 | ex2 | ex3;
endmodule

module normalise(input[23:0] M_result,
					input M_carry,
					input real_oper,
					output reg [22:0] normalized_M,
					output reg [4:0] shift
					);
			
reg [23:0] M_temp;
			
always @(*)
begin
	if(M_carry & !real_oper)
	begin
		normalized_M = M_result[23:1] + {22'b0,M_result[0]};
		shift = 5'd0;
	end
	else
	begin
		casex(M_result)
			24'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				normalized_M = M_result[22:0];
				shift = 5'd0;
			end
			24'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 1;
				normalized_M = M_temp[22:0];
				shift = 5'd1;
			end
			24'b001x_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 2;
				normalized_M = M_temp[22:0];
				shift = 5'd2;
			end			
			24'b0001_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 3;
				normalized_M = M_temp[22:0];
				shift = 5'd3;
			end			
			24'b0000_1xxx_xxxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 4;
				normalized_M = M_temp[22:0];
				shift = 5'd4;
			end			
			24'b0000_01xx_xxxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 5;
				normalized_M = M_temp[22:0];
				shift = 5'd5;
			end			
			24'b0000_001x_xxxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 6;
				normalized_M = M_temp[22:0];
				shift = 5'd6;
			end			
			24'b0000_0001_xxxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 7;
				normalized_M = M_temp[22:0];
				shift = 5'd7;
			end			
			24'b0000_0000_1xxx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 8;
				normalized_M = M_temp[22:0];
				shift = 5'd8;
			end			
			24'b0000_0000_01xx_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 9;
				normalized_M = M_temp[22:0];
				shift = 5'd9;
			end			
			24'b0000_0000_001x_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 10;
				normalized_M = M_temp[22:0];
				shift = 5'd10;
			end			
			24'b0000_0000_0001_xxxx_xxxx_xxxx:
			begin
				M_temp = M_result << 11;
				normalized_M = M_temp[22:0];
				shift = 5'd11;
			end			
			24'b0000_0000_0000_1xxx_xxxx_xxxx:
			begin
				M_temp = M_result << 12;
				normalized_M = M_temp[22:0];
				shift = 5'd12;
			end			
			24'b0000_0000_0000_01xx_xxxx_xxxx:
			begin
				M_temp = M_result << 13;
				normalized_M = M_temp[22:0];
				shift = 5'd13;
			end			
			24'b0000_0000_0000_001x_xxxx_xxxx:
			begin
				M_temp = M_result << 14;
				normalized_M = M_temp[22:0];
				shift = 5'd14;
			end			
			24'b0000_0000_0000_0001_xxxx_xxxx:
			begin
				M_temp = M_result << 15;
				normalized_M = M_temp[22:0];
				shift = 5'd15;
			end			
			24'b0000_0000_0000_0000_1xxx_xxxx:
			begin
				M_temp = M_result << 16;
				normalized_M = M_temp[22:0];
				shift = 5'd16;
			end			
			24'b0000_0000_0000_0000_01xx_xxxx:
			begin
				M_temp = M_result << 17;
				normalized_M = M_temp[22:0];
				shift = 5'd17;
			end			
			24'b0000_0000_0000_0000_001x_xxxx:
			begin
				M_temp = M_result << 18;
				normalized_M = M_temp[22:0];
				shift = 5'd18;
			end			
			24'b0000_0000_0000_0001_0001_xxxx:
			begin
				M_temp = M_result << 19;
				normalized_M = M_temp[22:0];
				shift = 5'd19;
			end			
			24'b0000_0000_0000_0000_0000_1xxx:
			begin
				M_temp = M_result << 20;
				normalized_M = M_temp[22:0];
				shift = 5'd20;
			end			
			24'b0000_0000_0000_0000_0000_01xx:
			begin
				M_temp = M_result << 21;
				normalized_M = M_temp[22:0];
				shift = 5'd21;
			end			
			24'b0000_0000_0000_0000_0000_001x:
			begin
				M_temp = M_result << 22;
				normalized_M = M_temp[22:0];
				shift = 5'd22;
			end			
			24'b0000_0000_0000_0000_0000_0001:
			begin
				M_temp = M_result << 23;
				normalized_M = M_temp[22:0];
				shift = 5'd23;
			end
			24'b0000_0000_0000_0000_0000_0000:
			begin
				M_temp = M_result << 24;
				normalized_M = M_temp[22:0];
				shift = 5'd24;
			end				
			default:
			begin
				normalized_M = 23'b0;
				shift = 5'd0;
			end			
		endcase	
	end
end										
											
endmodule