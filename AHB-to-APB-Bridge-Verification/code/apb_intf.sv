interface apb_intf(input Pclk);
 
  logic  Pwrite;
  logic [31:0] Pwdata;
  logic [31:0] Paddr;
  logic [31:0] Prdata;
  logic Penable;
  logic Pready;
  logic Psel;
  logic Pslverr;

  
endinterface