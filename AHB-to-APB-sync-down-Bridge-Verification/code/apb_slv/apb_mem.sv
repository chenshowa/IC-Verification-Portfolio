class apb_mem#(DW=`DATA_WIDTH,AW=`ADDR_WIDTH) extends uvm_object;

  `uvm_object_param_utils(apb_mem)
  logic [DW-1:0] mem[int];

  function new(string name = "apb_mem");
    super.new(name);
  endfunction

  task put_data(int addr, logic[DW-1:0] data); 
    this.mem[addr] = data;
  endtask

  function logic[DW-1:0] get_data(int addr);
    if(this.mem.exists(addr))begin
      get_data = this.mem[addr];
    end
    else begin
      get_data = $urandom_range(32'hffff_ffff);
//      `uvm_info(get_full_name(), $sformatf("APB-Memory un-defined Read.Address:%0h. Data:%0h.",addr,get_data),UVM_MEDIUM)
    end
  endfunction
endclass
