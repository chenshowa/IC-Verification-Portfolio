interface ahb_intf(input Hclk, input Hresetn);
  logic  Hwrite;
  logic [`DATA_WIDTH-1:0] Hwdata;
  logic [`ADDR_WIDTH-1:0] Haddr;
  logic [`DATA_WIDTH-1:0] Hrdata;
  logic Hresp,lock;
  logic Hreadyout;
  logic Hreadyin;
  logic Hsel;
  logic [1:0] Htrans;
  logic [2:0] Hsize;
  logic [3:0] Hprot;
  logic [2:0] Hburst;
  logic [3:0] Hflag;
  
  clocking mon_cb @(posedge Hclk);
    default input #1ns output #1ns;

    input   Hresetn;
    input   Hsel;
    input   Htrans;
    input   Haddr;
    input   Hprot;
    input   Hsize;
    input   Hwdata;
    input   Hwrite;
    input   Hrdata;
    input   Hreadyout;
    input   Hresp;
  endclocking
  
  clocking mst_cb @(posedge Hclk);
     default input #1ns output #1ns;

    input   Hresetn;
    output  Hsel;
    output  Htrans;
    output  Haddr;
    output  Hprot;
    output  Hsize;
    output  Hwdata;
    output  Hwrite;
    output  Hreadyin;
    input   Hrdata;
    input   Hreadyout;
    input   Hresp;
  endclocking
  
endinterface