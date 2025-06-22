
class apb_coverage extends uvm_component;
  
  `uvm_component_utils(apb_coverage)
  bit psel;
  bit penable;
  bit pwrite;
  bit [7:0]paddr;
  bit [31:0] pwdata;
  bit [31:0] prdata;
  bit pready;
  
  covergroup cg;
    option.per_instance = 1;
    e1: coverpoint psel {bins a = {0, 1};}
    e2: coverpoint penable {bins b = {0, 1};}
    e3: coverpoint pwrite {bins c = {0, 1};}
    e4: coverpoint paddr {
      bins low_addr_start = {8'h00};
      bins low_addr    = {[8'h01:8'h3F]};  
      bins middle_low     = {[8'h40:8'hBF]};  
      bins high_addr   = {[8'hC0:8'hFE]};  
      bins high_addr_end = {8'hFF};
    }          
    // 統計pwdata 每個位元在寫入操作中是否被觸發過(是否都曾經在取樣(sample)的當下為 '1')
    e5: coverpoint pwdata {bins a0 = {pwdata[0]}; 
                           bins a1 = {pwdata[1]};
                           bins a2 = {pwdata[2]};
                           bins a3 = {pwdata[3]};
                           bins a4 = {pwdata[4]};
                           bins a5 = {pwdata[5]};
                           bins a6 = {pwdata[6]};
                           bins a7 = {pwdata[7]};
                           bins a8 = {pwdata[8]};
                           bins a9 = {pwdata[9]};
                           bins b0 = {pwdata[10]};
                           bins b1 = {pwdata[11]};
                           bins b2 = {pwdata[12]};
                           bins b3 = {pwdata[13]};
                           bins b4 = {pwdata[14]};
                           bins b5 = {pwdata[15]};
                           bins b6 = {pwdata[16]};
                           bins b7 = {pwdata[17]};
                           bins b8 = {pwdata[18]};
                           bins b9 = {pwdata[19]};
                           bins c0 = {pwdata[20]};
                           bins c1 = {pwdata[21]};
                           bins c2 = {pwdata[22]};
                           bins c3 = {pwdata[23]};
                           bins c4 = {pwdata[24]};
                           bins c5 = {pwdata[25]};
                           bins c6 = {pwdata[26]};
                           bins c7 = {pwdata[27]};
                           bins c8 = {pwdata[28]};
                           bins c9 = {pwdata[29]};
                           bins d0 = {pwdata[30]};
                           bins d1 = {pwdata[31]};
                          }
    e6: coverpoint prdata {bins a0 = {pwdata[0]}; 
                           bins a1 = {pwdata[1]};
                           bins a2 = {pwdata[2]};
                           bins a3 = {pwdata[3]};
                           bins a4 = {pwdata[4]};
                           bins a5 = {pwdata[5]};
                           bins a6 = {pwdata[6]};
                           bins a7 = {pwdata[7]};
                           bins a8 = {pwdata[8]};
                           bins a9 = {pwdata[9]};
                           bins b0 = {pwdata[10]};
                           bins b1 = {pwdata[11]};
                           bins b2 = {pwdata[12]};
                           bins b3 = {pwdata[13]};
                           bins b4 = {pwdata[14]};
                           bins b5 = {pwdata[15]};
                           bins b6 = {pwdata[16]};
                           bins b7 = {pwdata[17]};
                           bins b8 = {pwdata[18]};
                           bins b9 = {pwdata[19]};
                           bins c0 = {pwdata[20]};
                           bins c1 = {pwdata[21]};
                           bins c2 = {pwdata[22]};
                           bins c3 = {pwdata[23]};
                           bins c4 = {pwdata[24]};
                           bins c5 = {pwdata[25]};
                           bins c6 = {pwdata[26]};
                           bins c7 = {pwdata[27]};
                           bins c8 = {pwdata[28]};
                           bins c9 = {pwdata[29]};
                           bins d0 = {pwdata[30]};
                           bins d1 = {pwdata[31]};
                          }
    e7: coverpoint pready {bins d = {0, 1};}
  endgroup

  function new(string name = "apb_coverage", uvm_component parent);
    super.new(name, parent);
    cg = new();
  endfunction
endclass



class apb_subscriber extends uvm_component;
  
  `uvm_component_utils(apb_subscriber)
  
  uvm_analysis_imp #(apb_transaction, apb_subscriber) cov_analysis_export;
  
  apb_coverage my_cov;
  apb_transaction tr;
  
  function new(string name = "apb_subscriber", uvm_component parent);
    super.new(name, parent);
    cov_analysis_export = new("cov_analysis_export", this);
    my_cov = new("my_cov", this);
    tr = apb_transaction::type_id::create("tr", this);
  endfunction
  
  virtual function void write(apb_transaction tr);
    my_cov.psel = tr.psel; 
    my_cov.penable = tr.penable; 
    my_cov.pwrite = tr.pwrite; 
    my_cov.pwdata = tr.pwdata; 
    my_cov.paddr = tr.paddr; 
    my_cov.prdata = tr.prdata; 

    
    my_cov.cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage = %0g", my_cov.cg.get_inst_coverage()),UVM_MEDIUM)
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage psel   = %0g", my_cov.cg.e1.get_inst_coverage()),UVM_LOW)
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage pen    = %0g", my_cov.cg.e2.get_inst_coverage()),UVM_LOW)
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage pwrite = %0g", my_cov.cg.e3.get_inst_coverage()),UVM_LOW)
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage paddr  = %0g", my_cov.cg.e4.get_inst_coverage()),UVM_LOW)
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage pwdata = %0g", my_cov.cg.e5.get_inst_coverage()),UVM_LOW)
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage prdata = %0g", my_cov.cg.e6.get_inst_coverage()),UVM_LOW)
    `uvm_info("SUBSCRIBER", $sformatf("write Coverage pready = %0g", my_cov.cg.e7.get_inst_coverage()),UVM_LOW)
   
  endfunction
endclass


    

   