//AHB Monitor

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)
  
  ahb_trans pkt;
  virtual ahb_intf ahb_vif;
  
  uvm_analysis_port #(ahb_trans) h_port;
  
  extern function new(string name="ahb_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
    
    // 控制訊號
    task sample_address(ref ahb_trans pkt);
      pkt = ahb_trans::type_id::create("pkt");
      pkt.Hsel    = ahb_vif.mon_cb.Hsel;
      pkt.Haddr   = ahb_vif.mon_cb.Haddr;
      pkt.Hsize   = ahb_vif.mon_cb.Hsize; 
      pkt.Hwrite  = ahb_vif.mon_cb.Hwrite;
    endtask

    task sample_data(ref ahb_trans pkt);
      if (pkt.Hwrite)
        pkt.Hwdata = ahb_vif.mon_cb.Hwdata;
      else 
        pkt.Hrdata = ahb_vif.mon_cb.Hrdata;
      pkt.Hresp = ahb_vif.mon_cb.Hresp;
    endtask
    

    
endclass
    
    function ahb_monitor::new(string name="ahb_monitor",uvm_component parent);
      super.new(name,parent);
    endfunction
    
    function void ahb_monitor::build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual ahb_intf)::get(this,"","ahb_vif",ahb_vif))
        `uvm_fatal("MONITOR", "cannot get() vif")
      h_port = new("h_port", this);
    endfunction

    task ahb_monitor::run_phase(uvm_phase phase);

    while(1)begin
      @(ahb_vif.mon_cb)
      if(!ahb_vif.mon_cb.Hresetn)begin  
        pkt = null;
      end
      
      else begin
        if(ahb_vif.mon_cb.Hreadyout)begin

          
          //Data Phase採樣
          if(pkt != null)begin

            sample_data(pkt);
            h_port.write(pkt);
            
            //`uvm_info("PDataM", $sformatf(" Hreadyout= %h  Hwrite= %h Haddr= %h Hrdata= %h Hwdata= %h %0t",  pkt.Hreadyout,  pkt.Hwrite, pkt.Haddr, pkt.Hrdata, pkt.Hwdata, $time), UVM_LOW); 
            pkt = null;
          end

          // Address Phase採樣
          if(ahb_vif.mon_cb.Hsel & ahb_vif.mon_cb.Htrans[1])begin
            sample_address(pkt);
          end
        end
      end
    end
    endtask


    
