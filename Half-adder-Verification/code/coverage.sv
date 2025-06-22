class my_cov extends uvm_subscriber#(transaction);
  `uvm_component_utils(my_cov)
  protected bit[3:0] A;
  protected bit[3:0] B;
  
  covergroup my_coverage;
    
    option.comment="Coverage for an Adder";
    option.per_instance = 1; 
    
    val_A: coverpoint A 
    { 
      bins low_a  = {[0:7]};
      bins high_a = {[8:15]};
    }
    
    val_B: coverpoint B 
    { 
      bins low_b  = {[0:7]};
      bins high_b = {[8:15]};
    } 
  
    combi: cross val_A, val_B;
  endgroup: my_coverage
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    my_coverage=new();  
  endfunction: new
  
  function void write(transaction t);
    //`uvm_info(get_type_name(), $sformatf("Sampling A=%0h B=%0h", t.A, t.B), UVM_LOW)
    this.A = t.A;
    this.B = t.B;
    my_coverage.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
   `uvm_info(get_full_name(),$sformatf("Coverage is %0.2f %%", my_coverage.get_coverage()),UVM_LOW);
   `uvm_info(get_full_name(), $sformatf("write Coverage val_A  = %0.2f %%", my_coverage.val_A.get_inst_coverage()),UVM_LOW)
   `uvm_info(get_full_name(), $sformatf("write Coverage val_B = %0.2f %%", my_coverage.val_B.get_inst_coverage()),UVM_LOW)
   `uvm_info(get_full_name(), $sformatf("write Coverage combi = %0.2f %%", my_coverage.combi.get_inst_coverage()),UVM_LOW)
  endfunction
endclass
    