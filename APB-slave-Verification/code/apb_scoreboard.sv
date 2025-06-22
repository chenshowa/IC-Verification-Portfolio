// 可以apb_scoreboard刪掉了因為沒有用到

`uvm_analysis_imp_decl(_expdata)
`uvm_analysis_imp_decl(_actdata)

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp_expdata#(apb_transaction, apb_scoreboard) mon_export;

//  uvm_analysis_imp#(apb_transaction, apb_scoreboard) mon_export;

  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_export = new("mon_export", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
 
  apb_transaction exp_queue[$];
 //virtual function void write_actdata(apb_transaction tr);
 function void write_actdata(input apb_transaction tr);
    apb_transaction expdata;
    if(exp_queue.size()) begin
      expdata =exp_queue.pop_front();
      if(tr.compare(expdata))begin
        `uvm_info("apb_scoreboard",$sformatf("MATCHED"),UVM_LOW)
      end
      else begin
        `uvm_info("apb_scoreboard",$sformatf("MISMATCHED"),UVM_LOW)
      end
    end
  endfunction
  
 //virtual function void write_expdata(apb_transaction tr);  
  function void write_expdata(input apb_transaction tr);
    exp_queue.push_back(tr);
  endfunction
                            
endclass
                            
        
      
    
    
  
    
  
  