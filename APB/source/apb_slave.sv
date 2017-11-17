`include "definesPkg.vh"
`include "apb_if.vh"
import definesPkg::*;

module apb_slave
(
  input logic clk,
  input logic rst_n ,
  //apb_if.slave apb_slave
  input        [APB_ADDR_WIDTH-1:0] PADDR,
  input                        PWRITE,
  input                        PSEL,
  input                        PENABLE,
  input        [APB_DATA_WIDTH-1:0] PWDATA,
  output logic [APB_DATA_WIDTH-1:0] PRDATA
);

logic [APB_DATA_WIDTH-1:0] mem [256];

typedef enum logic [1:0] {SETUP, W_ENABLE, R_ENABLE}
state_type;
state_type  apb_st;

// SETUP -> ENABLE
always_ff @(posedge clk, negedge rst_n) begin
  if (~rst_n) begin
    apb_st <= SETUP;
    PRDATA <= 0;
    mem <= '{default: '0};
  end

  else begin
    case (apb_st)
      SETUP : begin
        // clear the PRDATA
        PRDATA <= 0;

        // Move to ENABLE when the psel is asserted
        if (PSEL && !PENABLE) begin
          if (PWRITE) begin
            apb_st <= W_ENABLE;
          end

          else begin
            apb_st <= R_ENABLE;
          end
        end
      end

      W_ENABLE : begin
        // write pwdata to memory
        if (PSEL && PENABLE && PWRITE) begin
          mem[PADDR] <= PWDATA;
        end

        // return to SETUP
        apb_st <= SETUP;
      end

      R_ENABLE : begin
        // read PRDATA from memory
        if (PSEL && PENABLE && !PWRITE) begin
          PRDATA <= mem[PADDR];
        end

        // return to SETUP
        apb_st <= SETUP;
      end
    endcase
  end
end
endmodule
