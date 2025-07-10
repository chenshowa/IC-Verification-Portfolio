class func_cov extends uvm_object;
  
  covergroup cg with function sample(ahb_trans ahb_pkt); 
    option.per_instance = 1;
    haddr:coverpoint ahb_pkt.Haddr[15:0] {bins a1    = {16'h0000};
                                          bins a2    = {16'h0001};
                                          bins a3    = {16'h0002};
                                          bins a4    = {16'h0003};
                                          bins a5    = {16'hffff};
                                          bins a6    = {16'hfffe};
                                          bins a7    = {16'hfffd};
                                          bins a8    = {16'hfffc};
                                          bins a9[4] = {[16'h0004:16'hfffb]};
                                          }
    hwrite:coverpoint ahb_pkt.Hwrite;
    hsize :coverpoint ahb_pkt.Hsize[2:0] {bins b1    = {3'b001};
                                          bins b2    = {3'b010};
                                          bins b3    = {3'b011};
                                         }

    cross haddr,hwrite,hsize;
  endgroup
  
  function new(string name="coverage");
    super.new(name);
    cg=new();
    cg.set_inst_name({get_full_name,".",name,".cg"});
  endfunction

  
endclass
