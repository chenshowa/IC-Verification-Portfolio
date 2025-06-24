//--------------------------------------------
// This DUT features built-in memory storage and adheres to the APB3 protocol  
// specification with one notable exception: the PSLVERR port is not supported
// in this implementation.
//--------------------------------------------

interface dutintf;
  logic clk;
  logic rst_n;
  logic [7:0] paddr;
  logic pwrite;
  logic penable;
  logic psel;
  logic [31:0] prdata;
  logic pready;
  //logic pslverr; // not supported
  logic [31:0] pwdata;

  clocking drv_cb @(posedge clk);
    default input #1step output #1step;

    output paddr;
    output pwrite;
    output penable;
    output psel;
    output pwdata;
    output rst_n;

    input prdata;
    input pready;
  endclocking

  clocking bus_cb @(posedge clk);
    default input #1step output #1step;
    input paddr;
    input pwrite;
    input penable;
    input psel;
    input prdata;
    input pready;
    input pwdata;
    input rst_n;
  endclocking

  modport DRIVER (clocking drv_cb, input clk, output rst_n);
  modport MONITOR (clocking bus_cb, input clk);
endinterface


module apb_slave(dutintf dif);
  // 內部記憶體
  logic [31:0] mem [256];
  // delay參數
  int DELAY_LIMIT = 2;
  
  logic [1:0] apb_st;
  localparam SETUP    = 2'b00;
  localparam W_ENABLE = 2'b01;
  localparam R_ENABLE = 2'b10;
  
  logic [1:0] delay_counter;

  always @(negedge dif.rst_n or posedge dif.clk) begin
    if (dif.rst_n == 0) begin
      apb_st        <= SETUP;
      dif.prdata    <= '0;
      dif.pready    <= 0; 
      delay_counter <= 0;
    end
    else begin
      case (apb_st)
        SETUP : begin
          dif.pready <= 0;
          if (dif.psel && !dif.penable) begin


            delay_counter = $urandom_range(DELAY_LIMIT, 0); 


            if (dif.pwrite) begin
              apb_st <= W_ENABLE;
              $display("[%0t] SETUP: Moving to W_ENABLE, addr=%h", $time, dif.paddr);
            end
            else begin
              apb_st <= R_ENABLE;
              $display("[%0t] SETUP: Moving to R_ENABLE, addr=%h", $time, dif.paddr);
            end
          end
        end
        
        W_ENABLE : begin
          if (dif.psel && dif.penable) begin
            if (delay_counter == 0) begin
              mem[dif.paddr] <= dif.pwdata;
              dif.pready     <= 1; 
              apb_st         <= SETUP; 
              $display("[%0t] ACCESS: Writing %h to mem[%h], PREADY asserted.", $time, dif.pwdata, dif.paddr);
            end
            else begin
              delay_counter <= delay_counter - 1;
              dif.pready    <= 0; 
            end
          end

          else if (!dif.psel) begin
            apb_st <= SETUP;
          end
        end
        
        R_ENABLE : begin
          if (dif.psel && dif.penable) begin
            if (delay_counter == 0) begin
              dif.prdata <= mem[dif.paddr];
              dif.pready <= 1; 
              apb_st     <= SETUP; 
              $display("[%0t] ACCESS: Reading mem[%h] = %h, PREADY asserted.", $time, dif.paddr, mem[dif.paddr]);
            end
            else begin
              delay_counter <= delay_counter - 1;
              dif.pready    <= 0; 
            end
          end

          else if (!dif.psel) begin
            apb_st <= SETUP;
          end
        end
        
        default: begin
            apb_st <= SETUP;
        end
      endcase
    end
  end
endmodule
