module assertion( 
  input clk,
  input rst_n,
  input [3:0] A,      
  input [3:0] B,      
  input [4:0] Sum
  );
  

// AST_001: Reset功能檢查
property reset_functionality;
  @(posedge clk) !rst_n |=> (Sum == 5'b0);
endproperty
assert_reset_clears_sum: assert property(reset_functionality)
  else $error("AST_001 FAIL: Reset should clear Sum to 0, A=%0d, B=%0d, but Sum = %0d",   A, B, Sum);
  
// AST_002: 正常加法功能檢查
property addition;
  logic [4:0] expected_sum;
  @(posedge clk) disable iff(!rst_n)
  (1, expected_sum = A + B) |=> (Sum == expected_sum);
endproperty
assert_addition: assert property(addition)
  else $error("AST_002 FAIL: Addition incorrect. A=%0d, B=%0d, Expected=%0d, Actual=%0d",  A, B, A+B, Sum);
  
// AST_003: 輸出範圍檢查 - Sum不應超過最大可能值30 (15+15)
property output_range_check;
  @(posedge clk) disable iff(!rst_n)
  	Sum <= 5'h1E;  
endproperty
assert_output_in_range: assert property(output_range_check)
  else $error("AST_003 FAIL: Sum exceeds maximum possible value. A=%0d, B=%0d Sum = %0d",   A, B, Sum);


// AST_004: 進位檢查 - 當A+B > 15時，Sum[4]應為1
property carry_generation;
  @(posedge clk) disable iff(!rst_n)
  ((A + B) > 5'h0F) |=> Sum[4];
endproperty
assert_carry_bit_set: assert property(carry_generation)
    else $error("AST_004 FAIL: Carry bit not set when A+B > 15. A=%0d, B=%0d, Sum=%0d",  A, B, Sum);


// AST_005: 無進位檢查 - 當A+B <= 15時，Sum[4]應為0
property no_carry_generation;
  @(posedge clk) disable iff(!rst_n) 
  ((A + B) <= 5'h0F) |=> !Sum[4];
endproperty
assert_no_carry_bit: assert property(no_carry_generation)
    else $error("AST_005 FAIL: Carry bit set when A+B <= 15. A=%0d, B=%0d, Sum=%0d", A, B, Sum);
  
endmodule