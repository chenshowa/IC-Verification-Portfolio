class case0_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(case0_sequence)

  typedef struct {
    bit[3:0] A_val;
    bit[3:0] B_val;
    bit[4:0] expected_sum;
    string description;
  } test_vector_t;
  
  test_vector_t test_vectors[$];
  
  function new(string name = "case0_sequence");
    super.new(name);
    `uvm_info("case0_sequence", "jump into case0_sequence", UVM_LOW)
    //    test_vectors.push_back('{被加數, 加數, 和, "example"});           

    test_vectors.push_back('{4'h0, 4'h0, 5'h00, "zero plus zero"});           
    test_vectors.push_back('{4'h1, 4'h1, 5'h02, "basic addition"});   
    test_vectors.push_back('{4'h7, 4'h8, 5'h0F, "Medium value additionn"}); 
    test_vectors.push_back('{4'hF, 4'hF, 5'h1E, "Maximum addition"});    
    test_vectors.push_back('{4'h1, 4'hF, 5'h10, "corner case"});    
    test_vectors.push_back('{4'h8, 4'h8, 5'h10, "corner case"});     

  endfunction
  
  virtual task body(); 
    if(starting_phase != null) 
        starting_phase.raise_objection(this);

    foreach(test_vectors[i]) begin
      req = transaction::type_id::create($sformatf("basic_add_req_%0d", i)); 
      start_item(req);
      
      req.A = test_vectors[i].A_val;
      req.B = test_vectors[i].B_val;
      req.rst_n = 1'b1;  
      
      `uvm_info("case0_sequence", 
                $sformatf("Test Vector %0d: %s - A=0x%h, B=0x%h, Expected=0x%h", 
                        i, test_vectors[i].description, 
                        test_vectors[i].A_val, test_vectors[i].B_val, 
                        test_vectors[i].expected_sum), UVM_MEDIUM);
      
      finish_item(req);
      
      #10;
      
    end
    if(starting_phase != null) 
      starting_phase.drop_objection(this);

    `uvm_info("case0_sequence", "Basic Addition Sequence Completed", UVM_LOW);
  endtask
endclass


class my_case1 extends base_test; 

  function new(string name = "my_case1", uvm_component parent = null);
    super.new(name,parent);
  endfunction 
  
  extern virtual function void build_phase(uvm_phase phase); 
     
  virtual task run_phase(uvm_phase phase);
    
    case0_sequence seq;
    phase.raise_objection(this);
    seq = case0_sequence::type_id::create("case0_seq");
    seq.start(ENV.agnt.sqr);

    phase.drop_objection(this);
    
  endtask

  `uvm_component_utils(my_case1) 
      
endclass


function void my_case1::build_phase(uvm_phase phase);
   super.build_phase(phase);
  `uvm_info("my_case1", "jump to my_case1", UVM_LOW);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                              "env.i_agt.sqr.main_phase",
                              "default_sequence",  
                              case0_sequence::type_id::get());
endfunction
