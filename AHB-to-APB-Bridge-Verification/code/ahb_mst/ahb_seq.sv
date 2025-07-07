// Base sequence class
class ahb_mst_basic_seq extends uvm_sequence#(ahb_trans);
  `uvm_object_utils(ahb_mst_basic_seq)
  ahb_trans tx;
  
  typedef struct {
    bit Hwrite;
    bit [`ADDR_WIDTH-1:0] Haddr;
    bit [`DATA_WIDTH-1:0] Hwdata;
  } test_vector_t;
  test_vector_t test_vectors[$];
  
  function new(string name="ahb_mst_basic_seq");
    super.new(name);
  endfunction

  task body();
    foreach(test_vectors[i]) begin
      tx = ahb_trans::type_id::create($sformatf("tx_%0d", i));
      start_item(tx);
      tx.Hwrite = test_vectors[i].Hwrite;
      tx.Hwdata = test_vectors[i].Hwdata;
      tx.Haddr = test_vectors[i].Haddr;
      `uvm_info("AHB_BASIC_SEQ", $sformatf("AHB basic sequence sent tx_%0d", i), UVM_LOW);
      finish_item(tx);
      `uvm_info("AHB_BASIC_SEQ", $sformatf("AHB basic sequence tx_%0d finished", i), UVM_LOW);
    end
  endtask
endclass


// Burst transfer sequence
class ahb_mst_burst extends ahb_mst_basic_seq;
  `uvm_object_utils(ahb_mst_burst)
  
  function new(string name="ahb_mst_burst");
    super.new(name);  
    // Burst transfer pattern
    for (int i = 0; i < `burst_size; i++) begin
      if (i < `burst_size/2) // write burst
        test_vectors.push_back('{1'b1, 32'h00000008 + (i*8), 32'h00000008 + (i*8)});
      else // Read burst
        test_vectors.push_back('{1'b0, 32'h00000000 + `burst_size*4 - ((i-`burst_size/2) * 8), 32'h00000000});
    end
  endfunction
endclass



// Back-to-back transfer sequence
class ahb_mst_back2back extends ahb_mst_basic_seq;
  `uvm_object_utils(ahb_mst_back2back)
  
  function new(string name="ahb_mst_back2back");
    super.new(name);
    // Back-to-back transfer pattern
    for (int i = 0; i < `burst_size/2; i++) begin
      // Write operation
      test_vectors.push_back('{1'b1, 32'h00000008 + (i*8), 32'h00000008 + (i*8)});
      // read operation to same address
      test_vectors.push_back('{1'b0, 32'h00000008 + (i*8), 32'h00000008 + (i*8)});
    end
  endfunction

endclass