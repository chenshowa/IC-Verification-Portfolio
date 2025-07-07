`include "uvm_macros.svh"
//import uvm_pkg::*;
`include "definition.sv"
`include "ahb_intf.sv"
`include "apb_intf.sv"
`include "package.sv"
`include "test.sv"


module tb_top;
  int HCLK_PCLK_RATIO = 4;
  
  
  bit hclk;
  bit reset_n;
  bit Pclken=1;
  bit APBACTIVE;
  logic  [3:0] PSTRB;
  logic  [2:0] PPROT;
  
  initial begin
    hclk = 1'b0;
    forever 
      #5 hclk = ~hclk;
  end
  initial begin 
    reset_n = 0;      
    #15;            
    reset_n = 1;      
  end
  


reg pclk_en;
reg [3:0] hclk_cnt;
wire pclk;
reg pclk_en_r;


always@(posedge hclk or negedge reset_n)
begin
  if(!reset_n)
		hclk_cnt <= 4'b0;
	else if(hclk_cnt == HCLK_PCLK_RATIO - 1'b1)
		hclk_cnt <= 4'b0;
	else 
		hclk_cnt <= hclk_cnt + 1'b1;
end

  always@(negedge hclk or negedge reset_n)
begin
  if(!reset_n)
		pclk_en <= 1'b0;
	else if(hclk_cnt == HCLK_PCLK_RATIO - 1'b1)
		pclk_en <= 1'b1;
	else 
		pclk_en <= 1'b0;
end

  
  
always@(*) begin
	#1ns;
	pclk_en_r = pclk_en;
end
//generate pclk	
assign pclk = pclk_en_r & hclk;

  
  
ahb_intf ahb_vif(hclk, reset_n);
apb_intf apb_vif(pclk, reset_n);
  
  
cmsdk_ahb_to_apb DUT (
  .HCLK(hclk), 
  .HRESETn (reset_n), 
  .PCLKEN(pclk_en),

  .HSEL(ahb_vif.Hsel), 
  .HADDR(ahb_vif.Haddr), 
  .HTRANS(ahb_vif.Htrans), 
  .HSIZE(ahb_vif.Hsize),    
  .HPROT(ahb_vif.Hprot), 
  .HWRITE(ahb_vif.Hwrite), 
  .HREADY(ahb_vif.Hreadyout),
  .HWDATA(ahb_vif.Hwdata), 
  .HREADYOUT(ahb_vif.Hreadyout),  
  .HRDATA(ahb_vif.Hrdata), 
  .HRESP(ahb_vif.Hresp), 
  	
  
  .PADDR(apb_vif.Paddr), 
  .PENABLE(apb_vif.Penable), 
  .PWRITE(apb_vif.Pwrite), 

  .PSTRB(PSTRB),
  .PPROT(PPROT),
  .PWDATA(apb_vif.Pwdata), 
  .PSEL(apb_vif.Psel), 
  .APBACTIVE(APBACTIVE),
  .PRDATA(apb_vif.Prdata), 
  .PREADY(apb_vif.Pready), 
  .PSLVERR(apb_vif.Pslverr));
  

  
  initial begin
    uvm_config_db#(virtual ahb_intf)::set(uvm_root::get(), "*", "ahb_vif", ahb_vif);
    uvm_config_db#(virtual apb_intf)::set(uvm_root::get(), "*", "apb_vif", apb_vif);
  end
  
  initial begin
    run_test("test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end

  
  assertion_bridge assert_bridge( ahb_vif, apb_vif );
  assertion_ahb assert_ahb( ahb_vif );
  assertion_apb assert_apb( apb_vif );
  
endmodule
  
  


