//AHB Driver

class ahb_drv extends uvm_driver#(ahb_trans);

  ahb_trans tx;

  protected ahb_trans pkt_dpha = null;
  protected ahb_trans pkt_apha = null;

  virtual ahb_intf ahb_vif;
  `uvm_component_utils(ahb_drv);

  function new(string name="ahb_drv",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual ahb_intf)::get(this,"","ahb_vif",ahb_vif))
      `uvm_fatal("AHB Driver","error in getting interface");
    tx = ahb_trans::type_id::create("tx");
  endfunction


  //Run Phase
  task run_phase(uvm_phase phase);
    while(1) begin
      @(ahb_vif.mst_cb);
      if(!ahb_vif.mst_cb.Hresetn)begin
        ahb_vif.mst_cb.Hsel   <= 1'b0;
        ahb_vif.mst_cb.Haddr  <= 32'b0;
        ahb_vif.mst_cb.Htrans <= 2'b0;
        ahb_vif.mst_cb.Hsize  <= 3'b0;
        ahb_vif.mst_cb.Hwrite <= 1'b0;
        ahb_vif.mst_cb.Hwdata <= 32'b0;
      end
      else begin
        if(pkt_dpha != null)begin
          // 資料階段
          drive_1cyc_pkt_data(pkt_dpha); 

          if(ahb_vif.mst_cb.Hreadyout)begin
            seq_item_port.item_done();
            pkt_apha = null;
            pkt_dpha = null;
            `uvm_info("AHB_drv", $sformatf("Finished"), UVM_LOW);
          end
        end


        if(pkt_apha == null)begin

          seq_item_port.try_next_item(pkt_apha);
          if(pkt_apha != null)begin
            drive_1cyc_pkt_address(pkt_apha);
            pkt_apha.print();

            `uvm_info("AHB_drv", $sformatf("Adddress Phase"), UVM_LOW);
          end
          else begin
            drive_1cyc_idle();

          end
        end
      end
    end
  endtask


  task drive_1cyc_pkt_data(ref ahb_trans pkt);
    if(ahb_vif.mst_cb.Hreadyout)begin

      if (pkt.Hwrite) // write
        ahb_vif.mst_cb.Hwdata <=  pkt.Hwdata;
      else  // read
        ahb_vif.mst_cb.Hwdata <=  32'd0;

    end
  endtask

  task drive_1cyc_pkt_address(ref ahb_trans pkt);
    if(ahb_vif.mst_cb.Hreadyout)begin
      ahb_vif.mst_cb.Hsel   <= 1'b1; 
      ahb_vif.mst_cb.Haddr  <= pkt.Haddr;
      ahb_vif.mst_cb.Hsize  <= 3'b010;
      ahb_vif.mst_cb.Hwrite <= pkt.Hwrite;
      ahb_vif.mst_cb.Htrans <= 2'b10;  
      ahb_vif.mst_cb.Hprot <= 4'b0011;

      this.pkt_dpha = this.pkt_apha; 
    end
  endtask

  task drive_1cyc_idle();
    ahb_vif.mst_cb.Hsel   <= 1'b0;
    ahb_vif.mst_cb.Haddr  <= 32'd0;
    ahb_vif.mst_cb.Hprot  <= 4'h0;
    ahb_vif.mst_cb.Hwrite <= 1'b0;
  endtask

endclass
    

    
 
