module assertion( 

  input clk,
  input rst_n,
  input [7:0] paddr,
  input pwrite,
  input penable,
  input psel,
  input [31:0] prdata,
  input pready,
  input [31:0] pwdata
  
);

  // 狀態轉換 IDLE to SETUP  
  property state_transition_idle_to_setup;
    @(posedge clk) disable iff (!rst_n)
    (!psel && !penable) ##1 (psel || penable) 
    |->(psel && !penable); // 
  endproperty
  assert_idle_to_setup_only: assert property (state_transition_idle_to_setup)
    else $error("AST_001 FAIL: IDLE state can only transition to SETUP state");
 
   // 狀態轉換 SETUP to ACCESS
  property state_transition_setup_to_access;
    @(posedge clk) disable iff (!rst_n)
    (psel && !penable) |=> penable;
  endproperty
  assert_transition_setup_to_access: assert property (state_transition_setup_to_access)
    else $error("AST_002 FAIL: State transition from SETUP to ENABLE failed");
  
  // 狀態轉換 ACCESS from SETUP        
  property state_access_after_setup;
    @(posedge clk) disable iff (!rst_n)
    (psel && penable) |->##[1:16] $past(psel && !penable);
  endproperty
  assert_access_after_setup: assert property (state_access_after_setup)
    else $error("AST_003 FAIL: ACCESS must be preceded by a valid SETUP phase");

  // 狀態轉換 ACCESS to SETUP or IDLE  
  property state_access_transition;
    @(posedge clk) disable iff (!rst_n)
    (psel && penable) |=> ##[1:16] (!psel || (psel && !penable));
  endproperty
  assert_access_transition: assert property (state_access_transition)
    else $error("AST_004 FAIL: ACCESS must transition to IDLE or next SETUP");

  // SETUP狀態的信號要求pwrite穩定
  property apb_setup_pwrite_stable;
    @(posedge clk) (psel && !penable) |=> $stable(pwrite);
  endproperty
  assert_apb_write_stable: assert property (apb_setup_pwrite_stable)
    else $error("AST_005 FAIL: APB pwrite signal not stable in SETUP phase");
    
  // ACCESS狀態的信號要求pwrite和paddr穩定
  property apb_access_pwrite_paddr_stable;
    @(posedge clk) (psel && penable) |-> 
    $stable(paddr) && $stable(pwrite);
  endproperty
  assert_apb_pwrite_paddr_stable: assert property (apb_access_pwrite_paddr_stable)
    else $error("AST_006 FAIL: ACCESS phase violation - signals not stable");
   
  // PREADY信號只能在APB存取週期（ACCESS phase）中被拉高
  apb_pready_in_access: assert property (
    @(posedge clk)
    pready |-> (psel && penable) 
  ) else $error("AST_007 FAIL: PREADY should only be asserted during ACCESS");
    
    
  // 重置行為
  property reset_behavior;
    @(posedge clk) (!rst_n) |-> ( prdata == 32'h0);
  endproperty
  assert_reset: assert property (reset_behavior)
    else $error("AST_008 FAIL: Reset behavior violation");
  

    
    
endmodule