interface ahb_intf(input Hclk);
  
  logic  Hwrite;
  logic [31:0] Hwdata;
  logic [31:0] Haddr;
  logic [31:0] Hrdata;
  logic Hresp;
  logic Hreadyout;
  logic Hreadyin;
  logic Hsel;
  logic [1:0] Htrans;
  logic [2:0] Hsize;
 
  
endinterface