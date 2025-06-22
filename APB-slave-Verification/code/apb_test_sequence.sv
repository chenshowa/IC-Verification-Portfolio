class apb_test_sequence extends uvm_sequence#(apb_transaction);
  
  `uvm_object_utils(apb_test_sequence)
  
  virtual dutintf vintf;
  apb_transaction tr;
  
  logic [31:0] expected_data;
  logic [7:0] test_addr;
  bit [31:0] read_data;
  int error_count = 0;
  
  function new(string name = "");
    super.new(name);
  endfunction
  
  task body();
    begin
      if (!uvm_config_db#(virtual dutintf)::get(null, get_full_name(), "vintf", vintf)) 
          `uvm_fatal("NOVIF", "Virtual interface not found in config db")
     

       
      // Test Case 1: read after write測試
      test_addr = 8'h10;
      expected_data = 32'hddddaaaa;
    
      apb_write(test_addr, expected_data);

      apb_read(test_addr, read_data);

      if(read_data == expected_data) begin
        `uvm_info("APB_TEST", $sformatf("PASSED! Expected: %h, Got: %h", expected_data, read_data), UVM_LOW)
      end else begin
        `uvm_error("APB_TEST", $sformatf("FAILED! Expected: %h, Got: %h", expected_data, read_data))
      end
        


      // Test Case 2: 多地址寫入讀取測試
      `uvm_info("APB_TEST", "\n--- Test Case 2: Multiple Address Test ---", UVM_LOW)
      for (int i = 0; i < 10; i++) begin
        test_addr = i * 10;
        expected_data = 32'hA0000000 + i;
        apb_write(test_addr, expected_data);
      end
      
      
      for (int i = 0; i < 10; i++) begin
        test_addr = i * 10;
        expected_data = 32'hA0000000 + i;
        apb_read(test_addr, read_data);
        
        if (read_data != expected_data) begin
          `uvm_error("APB_TEST", $sformatf("FAIL: Addr 0x%02x Expected 0x%08x, Got 0x%08x", 
                      test_addr, expected_data, read_data))
          error_count++;
        end
        
        else begin
           `uvm_info("APB_TEST", $sformatf("passss: Addr 0x%02x Expected 0x%08x, Got 0x%08x", test_addr, expected_data, read_data), UVM_LOW)
        end  
      end


      // Test Case 3: 邊界地址測試
      `uvm_info("APB_TEST", "\n--- Test Case 3: Boundary Address Test ---", UVM_LOW)
      // 測試邊界地址0和255
      apb_write(8'h00, 32'h12345678);
      apb_write(8'hFF, 32'h87654321);
      
      repeat(2) @(posedge vintf.clk); 
      apb_read(8'h00, read_data);
      if (read_data == 32'h12345678) 
        `uvm_info("APB_TEST", "PASS: Address 0x00 test", UVM_LOW)
      else begin
        `uvm_info("APB_TEST", "FAIL: Address 0x00 test", UVM_LOW)
        error_count++;
      end
      
      apb_read(8'hFF, read_data);
      if (read_data == 32'h87654321)
        `uvm_info("APB_TEST", "PASS: Address 0xFF test", UVM_LOW)
      else begin
        `uvm_info("APB_TEST", "FAIL: Address 0xFF test", UVM_LOW)
        error_count++;
      end
     
      // Test Case 4: 重置測試
      `uvm_info("APB_TEST", "\n--- Test Case 4: Reset Test ---", UVM_LOW)
      // 寫入一些資料
      apb_write(8'h50, 32'hCAFEBABE);
      
      
      // 重置系統
      vintf.rst_n = 1'b0;
      repeat(3) @(posedge vintf.clk);
      vintf.rst_n = 1'b1;
      repeat(2) @(posedge vintf.clk);
      
      // 檢查prdata是否被清零
      if (vintf.prdata == 32'h00000000)
        `uvm_info("APB_TEST", "PASS: Reset clears prdata", UVM_LOW)
      else begin
        `uvm_info("APB_TEST", "FAIL: Reset does not clear prdata", UVM_LOW)
        error_count++;
      end
      
      // 記憶體內容在重置後應該保持（因為沒有明確重置）
      apb_read(8'h50, read_data);
      if (read_data == 32'hCAFEBABE)
        `uvm_info("APB_TEST", "PASS: Memory content preserved after reset", UVM_LOW)
      else begin
        `uvm_info("APB_TEST", "FAIL: Memory content not preserved after reset", UVM_LOW)
        error_count++;
      end
      
        

      // Test Case 5: 連續存取測試
      `uvm_info("APB_TEST", "\n--- Test Case 5: Back-to-back Access Test ---", UVM_LOW)
      apb_write(8'h20, 32'h11111111);
      apb_read(8'h20, read_data);
      apb_write(8'h21, 32'h22222222);
      apb_read(8'h21, read_data);
      `uvm_info("APB_TEST", "PASS: Back-to-back access completed", UVM_LOW)
      

      
      // Test Case 6: 無效傳輸測試（不應該影響記憶體）
      `uvm_info("APB_TEST", "\n--- Test Case 6: Invalid Transaction Test ---", UVM_LOW)
      test_addr = 8'h30;
      expected_data = 32'h33333333;
      apb_write(test_addr, expected_data);

      
      // 測試：psel=0的情況
      @(posedge vintf.clk);
      vintf.psel <= 1'b0;  
      vintf.penable <= 1'b1;
      vintf.pwrite <= 1'b1;
      vintf.paddr <= test_addr;
      vintf.pwdata <= 32'hBBBBBBBB; 
      @(posedge vintf.clk);
      
      // 重置信號
      vintf.psel <= 1'b0;
      vintf.penable <= 1'b0;
      vintf.pwrite <= 1'b0;
      
      // 驗證原始資料沒有被覆蓋
      apb_read(test_addr, read_data);
      if (read_data == expected_data)
        `uvm_info("APB_TEST", "PASS: Invalid transaction does not affect memory", UVM_LOW)
      else begin
        `uvm_info("APB_TEST", $sformatf("FAIL: Invalid transaction corrupted memory read_data=0x%08h expected_data=0x%08h ", read_data, expected_data), UVM_LOW)
        error_count++;
      end
      
      
        
      // Test Case 7: 隨機寫入測試
      repeat(20) begin
 	    test_addr = $urandom_range(0, 255);
 	    apb_write(test_addr, 32'hFFFFFFFF);
 	 end 
 /*      
      */
      
   end
  endtask

  task apb_write(input [7:0] addr, input [31:0] data);
    
    // SETUP phase 
    `uvm_do_with(req, {
      req.paddr == addr; req.pwdata == data; 
      req.pwrite == 1'b1; req.penable == 1'b0; req.psel == 1'b1; 
    })
    
    // ACCESS phase  
    `uvm_do_with(req, {
      req.paddr == addr; req.pwdata == data;
      req.pwrite == 1'b1; req.penable == 1'b1; req.psel == 1'b1;
    })
    
    wait(vintf.DRIVER.drv_cb.pready == 1);
  endtask


  task apb_read(input [7:0] addr, output [31:0] data);
    
 
    // SETUP phase
    `uvm_do_with(req, {
      req.paddr == addr;
      req.pwrite == 1'b0; req.penable == 1'b0; req.psel == 1'b1;  req.pwdata == 32'h0; 
    })
    
    // ACCESS phase
    `uvm_do_with(req, {
      req.paddr == addr;
      req.pwrite == 1'b0; req.penable == 1'b1; req.psel == 1'b1;  req.pwdata == 32'h0; 
    })
    
    data = req.prdata;
    

  endtask
  
endclass
                   
                   