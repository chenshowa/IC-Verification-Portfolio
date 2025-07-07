//APB Interface

interface apb_intf(input Pclk, input Presetn);
 
  logic  Pwrite;
  logic [`DATA_WIDTH-1:0] Pwdata;
  logic [`ADDR_WIDTH-1:0] Paddr;
  logic [`DATA_WIDTH-1:0] Prdata;
  logic Penable;
  logic Pready;
  logic Psel;
  logic Pslverr;
  logic [3:0] Pflag;
  
  clocking mon_cb @(posedge Pclk);
    default input #1ns output #1ns;
    input Presetn;
    input  Psel;  
    input  Penable;  
    input  Pwrite;  
    input  Paddr;  
    input  Pwdata;
    input  Prdata;
    input  Pready;
    input  Pslverr; 
  endclocking
  
  clocking slv_cb @(posedge Pclk);
    default input #1ns output #1ns;
    input Presetn;
    input  Psel;  
    input  Penable;  
    input  Pwrite;  
    input  Paddr;  
    input  Pwdata;
    output Prdata;
    output Pready;
    output Pslverr; 
  endclocking
  
endinterface
