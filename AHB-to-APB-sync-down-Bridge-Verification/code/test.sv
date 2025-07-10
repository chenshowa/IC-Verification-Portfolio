class base_test extends uvm_test;
  `uvm_component_utils(base_test)
   env o_env;
  function new(string name="base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction
     
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    o_env=env::type_id::create("o_env",this);
  endfunction
      
endclass
    
class case_burst extends base_test; 
  `uvm_component_utils(case_burst) 

  ahb_mst_burst hseq;
  apb_seq pseq;
  
  function new(string name="case_burst", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    hseq = ahb_mst_burst::type_id::create("hseq",this);
    pseq = apb_seq::type_id::create("pseq",this);
  endfunction


  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("TEST", "Raised objection in test", UVM_LOW)
    fork
      hseq.start(o_env.h_agt.h_seqr);
      pseq.start(o_env.p_agt.p_seqr);
    join
    `uvm_info("TEST", "Dropping objection in test", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass

class case_back2back extends base_test; 
  `uvm_component_utils(case_back2back) 

  ahb_mst_back2back hseq;
  apb_seq pseq;
  
  function new(string name="case_back2back", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    hseq = ahb_mst_back2back::type_id::create("hseq",this);
    pseq = apb_seq::type_id::create("pseq",this);
  endfunction


  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("TEST", "Raised objection in test", UVM_LOW)
    fork
      hseq.start(o_env.h_agt.h_seqr);
      pseq.start(o_env.p_agt.p_seqr);
    join
    `uvm_info("TEST", "Dropping objection in test", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass