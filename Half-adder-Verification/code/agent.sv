class agent extends uvm_agent;
    sequencer sqr;
    driver drv;
    monitor mnt;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction:new
        
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      drv = driver::type_id::create("drv",this);
            mnt = monitor::type_id::create("mnt",this);
            sqr = sequencer::type_id::create("sequencer1",this);
    endfunction: build_phase
    
    function void connect_phase(uvm_phase phase);

        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction: connect_phase

    `uvm_component_utils(agent)
endclass: agent
    