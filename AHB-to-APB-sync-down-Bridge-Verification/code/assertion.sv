module assertion_apb( 
  apb_intf apb_intf
);

  // 狀態轉換 IDLE to SETUP  
  property state_transition_idle_to_setup;
    @(posedge apb_intf.Pclk) disable iff (!apb_intf.Presetn)
    (!apb_intf.Psel && !apb_intf.Penable) ##1 (apb_intf.Psel ||apb_intf.Penable) 
    |->(apb_intf.Psel && !apb_intf.Penable); // 
  endproperty
  assert_idle_to_setup_only: assert property (state_transition_idle_to_setup)
    else $error("AST_001 FAIL: IDLE state can only transition to SETUP state");
 
   // 狀態轉換 SETUP to ACCESS
  property state_transition_setup_to_access;
    @(posedge apb_intf.Pclk) disable iff (!apb_intf.Presetn)
    (apb_intf.Psel && !apb_intf.Penable) |=>apb_intf.Penable;
  endproperty
  assert_transition_setup_to_access: assert property (state_transition_setup_to_access)
    else $error("AST_002 FAIL: State transition from SETUP to ENABLE failed");
  
  // 狀態轉換 ACCESS from SETUP        
  property state_access_after_setup;
    @(posedge apb_intf.Pclk) disable iff (!apb_intf.Presetn)
    (apb_intf.Psel &&apb_intf.Penable) |->##[1:16] $past(apb_intf.Psel && !apb_intf.Penable);
  endproperty
  assert_access_after_setup: assert property (state_access_after_setup)
    else $error("AST_003 FAIL: ACCESS must be preceded by a valid SETUP phase");

  // 狀態轉換 ACCESS to SETUP or IDLE  
  property state_access_transition;
    @(posedge apb_intf.Pclk) disable iff (!apb_intf.Presetn)
    (apb_intf.Psel &&apb_intf.Penable) |=> ##[1:16] (!apb_intf.Psel || (apb_intf.Psel && !apb_intf.Penable));
  endproperty
  assert_access_transition: assert property (state_access_transition)
    else $error("AST_004 FAIL: ACCESS must transition to IDLE or next SETUP");

  // SETUP狀態的信號要求pwrite穩定
  property apb_setup_pwrite_stable;
    @(posedge apb_intf.Pclk) (apb_intf.Psel && !apb_intf.Penable) |=> $stable(apb_intf.Pwrite);
  endproperty
  assert_apb_write_stable: assert property (apb_setup_pwrite_stable)
    else $error("AST_005 FAIL: APB pwrite signal not stable in SETUP phase");
    
  // ACCESS狀態的信號要求pwrite和paddr穩定
  property apb_access_pwrite_paddr_stable;
    @(posedge apb_intf.Pclk) (apb_intf.Psel &&apb_intf.Penable) |-> 
    $stable(apb_intf.Paddr) && $stable(apb_intf.Pwrite);
  endproperty
  assert_apb_pwrite_paddr_stable: assert property (apb_access_pwrite_paddr_stable)
    else $error("AST_006 FAIL: ACCESS phase violation - signals not stable");
   
  // PREADY信號只能在APB存取週期（ACCESS phase）中被拉高
  apb_pready_in_access: assert property (
    @(posedge apb_intf.Pclk)
   apb_intf.Pready |-> (apb_intf.Psel &&apb_intf.Penable) 
  ) else $error("AST_007 FAIL: PREADY should only be asserted during ACCESS");
    
    

endmodule


module assertion_ahb( 
  ahb_intf ahb_intf
);


  // . AHB地址穩定性檢查
  property ahb_addr_stable;
      @(posedge ahb_intf.Hclk) disable iff (!ahb_intf.Hresetn)
      (ahb_intf.Hsel && ahb_intf.Htrans != 2'b00 && !ahb_intf.Hreadyout) |-> 
      ##1 $stable(ahb_intf.Haddr);
  endproperty
  assert property (ahb_addr_stable) else $error("AHB address not stable during wait state");


  // . AHB寫數據穩定性檢查
  property ahb_wdata_stable;
      @(posedge ahb_intf.Hclk) disable iff (!ahb_intf.Hresetn)
      (ahb_intf.Hsel && ahb_intf.Hwrite && !ahb_intf.Hreadyout) |-> 
      ##1 $stable(ahb_intf.Hwdata);
  endproperty
  assert property (ahb_wdata_stable) else $error("AHB write data not stable during wait state");

  // 重置行為
  property reset_behavior;
    @(posedge ahb_intf.Hclk) (!ahb_intf.Hresetn) |-> (ahb_intf.Hrdata == 32'h0);
  endproperty
  assert_reset: assert property (reset_behavior)
    else $error("Reset FAIL: Reset behavior violation");
  
    
  endmodule

module assertion_bridge( 
  ahb_intf ahb_intf,
  apb_intf apb_intf
);

  // . AHB選中時APB必須啟動
  property ahb_sel_apb_start;
      @(posedge ahb_intf.Hclk) disable iff (!ahb_intf.Hresetn)
      (ahb_intf.Hsel && ahb_intf.Htrans != 2'b00 && ahb_intf.Hreadyin) |-> 
      ##[1:2] apb_intf.Psel;
  endproperty
  assert property (ahb_sel_apb_start) else $error("APB not selected after AHB valid transfer");


  // . APB完成後AHB立即Ready
  property apb_complete_ahb_ready;
    @(posedge ahb_intf.Hclk) disable iff (!ahb_intf.Hresetn)
    ($fell(apb_intf.Psel) && apb_intf.Penable && apb_intf.Pready) |-> 
    ##[0:1] ahb_intf.Hreadyout;		
  endproperty
  assert property (apb_complete_ahb_ready) else $error("AHB not ready immediately after APB completion");

  endmodule