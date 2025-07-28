class func_cov extends uvm_object;
  
  covergroup cg with function sample(ahb_trans ahb_pkt, apb_trans apb_pkt);  // , apb_trans apb_pkt
    option.per_instance = 1;
    haddr:coverpoint ahb_pkt.Haddr[15:0] {bins a1    = {16'h0000};
                                          bins a2    = {16'h0001};
                                          bins a3    = {16'h0002};
                                          bins a4    = {16'hffff};
                                          bins a5    = {16'hfffe};
                                          bins a6    = {16'hfffd};
                                          bins a7[4] = {[16'h0003:16'hfffc]};
                                          //表示自動分桶（auto bin array）的語法。
                                          }
    hwdata:coverpoint ahb_pkt.Hwdata[15:0] {bins a1    = {16'h0000};
                                          bins a2    = {16'h0001};
                                          bins a3    = {16'h0002};
                                          bins a4    = {16'hffff};
                                          bins a5    = {16'hfffe};
                                          bins a6    = {16'hfffd};
                                          bins a7[4] = {[16'h0003:16'hfffc]};
                                          }
    prdata:coverpoint apb_pkt.Prdata[15:0] {bins a1    = {16'h0000};
                                          bins a2    = {16'h0001};
                                          bins a3    = {16'h0002};
                                          bins a4    = {16'hffff};
                                          bins a5    = {16'hfffe};
                                          bins a6    = {16'hfffd};
                                             bins a7[4] = {[16'h0003:16'hfffc]};
                                          }
    hwrite:coverpoint ahb_pkt.Hwrite;


    cross haddr,hwrite;
  endgroup
  
  function new(string name="func_cov");
    super.new(name);
    cg=new();
    cg.set_inst_name({get_full_name,".",name,".cg"});
  endfunction

  
endclass
