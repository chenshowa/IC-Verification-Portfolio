//AHB Sequencer

class ahb_seqr extends uvm_sequencer#(ahb_trans);
  `uvm_component_utils(ahb_seqr)
  extern function new(string name="ahb_seqr",uvm_component parent);
endclass
    
    function ahb_seqr::new(string name="ahb_seqr",uvm_component parent);
      super.new(name,parent);
    endfunction
