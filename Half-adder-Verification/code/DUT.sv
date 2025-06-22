module ADDER(
 	input logic clk, rst_n,
  input logic[3:0] A,B, 
  output logic[4:0] Sum 
  );

always@(posedge clk)
  if(!rst_n)
    Sum<=5'b0;
  else
    Sum<=A+B;
    
endmodule