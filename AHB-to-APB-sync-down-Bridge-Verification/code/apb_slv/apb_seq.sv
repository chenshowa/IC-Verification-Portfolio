//APB Sequence

class apb_seq extends uvm_sequence#(apb_trans);
  `uvm_object_utils(apb_seq)
  apb_trans tx;
  
  
  extern function new(string name="apb_seq");
  extern task body();
    
endclass
      
      function apb_seq::new(string name="apb_seq");
        super.new(name);
      endfunction
    
    task apb_seq::body();
      int i=0;
      repeat (`burst_size) begin
        tx=apb_trans::type_id::create("tx");
        start_item(tx);
        assert(tx.randomize());
        finish_item(tx);
        i++;
      end
      #100;
    endtask
