//APB Driver

class apb_drv extends uvm_driver#(apb_trans);
  
  apb_mem#(`DATA_WIDTH,`ADDR_WIDTH) mem;
  
  apb_trans tx;
  virtual apb_intf apb_vif;
  virtual ahb_intf ahb_vif;

  `uvm_component_utils(apb_drv)
  extern function new(string name="apb_drv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  
  extern task drive(apb_trans pkt);
  extern task drive_write_pkt(apb_trans pkt);  
  extern task drive_read_pkt(apb_trans pkt);  
endclass
    
    function apb_drv::new(string name="apb_drv",uvm_component parent);
      super.new(name,parent);
    endfunction
    
    function void apb_drv::build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual apb_intf)::get(this,"","apb_vif",apb_vif))
        `uvm_fatal("APB Driver","error in getting interface")
        
      tx = apb_trans::type_id::create("tx");
      mem = apb_mem#(32,32)::type_id::create("apb_mem",this);
    endfunction
    
    task apb_drv::run_phase(uvm_phase phase);
      apb_vif.slv_cb.Pready  <= 1'b0;
      apb_vif.slv_cb.Pslverr <= 1'b0;

   	  while(1)begin
         
        @(apb_vif.slv_cb);
        apb_vif.slv_cb.Pready  <= 1'b0;

        if(!apb_vif.slv_cb.Penable & apb_vif.slv_cb.Psel)begin
          
          seq_item_port.get_next_item(tx);
          drive(tx);
          seq_item_port.item_done();
        end
      end
      
      
    endtask
    

  task apb_drv::drive(apb_trans pkt); 
    int nready_cnt;
    nready_cnt = pkt.nready_num;      
    
    
    while(nready_cnt != 0)
      begin
        
        apb_vif.slv_cb.Pready <= 1'b0;
        nready_cnt--;
        @(apb_vif.slv_cb);

      end


    if(apb_vif.slv_cb.Pwrite) begin
      drive_write_pkt(pkt);
    end
    else begin
      drive_read_pkt(pkt);
    end

    apb_vif.slv_cb.Pready <= 1'b1;
    apb_vif.slv_cb.Pslverr<= pkt.slverr;
    
  endtask
  
  // write
  task apb_drv::drive_write_pkt(apb_trans pkt);
    if(!pkt.slverr)begin
      mem.put_data(apb_vif.slv_cb.Paddr, apb_vif.slv_cb.Pwdata);
    end
  endtask

  // read
    task apb_drv::drive_read_pkt(apb_trans pkt);
    if(!pkt.slverr)begin
      apb_vif.slv_cb.Prdata <= mem.get_data(apb_vif.slv_cb.Paddr);
    end
    else begin
      apb_vif.slv_cb.Prdata <= pkt.data;
    end
  endtask
    
    
    