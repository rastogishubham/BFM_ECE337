`include "definesPkg.vh"
`include "apb_if.vh"
import definesPkg::*;

module apb_slave
#(
  addrWidth = 32,
  dataWidth = 32
)
(
  input logic clk,
  input logic rst_n ,
  apb_if.slave apb_slave
  /*input                        clk,
  input                        rst_n,
  input        [addrWidth-1:0] paddr,//
  input                        pwrite,//
  input                        psel,//
  input                        penable,//
  input        [dataWidth-1:0] pwdata,//
  output logic [dataWidth-1:0] prdata//*/
);

logic [dataWidth-1:0] mem [256];

typedef enum logic [1:0] {SETUP, W_ENABLE, R_ENABLE}
state_type;
state_type  apb_st;

// SETUP -> ENABLE
always_ff @(posedge clk, negedge rst_n) begin
  if (~rst_n) begin
    apb_st <= SETUP;
    apb_slave.PRDATA <= 0;
    mem <= '{default: '0};
  end

  else begin
    case (apb_st)
      SETUP : begin
        // clear the apb_slave.PRDATA
        apb_slave.PRDATA <= 0;

        // Move to ENABLE when the psel is asserted
        if (apb_slave.PSEL && !apb_slave.PENABLE) begin
          if (apb_slave.PWRITE) begin
            apb_st <= W_ENABLE;
          end

          else begin
            apb_st <= R_ENABLE;
          end
        end
      end

      W_ENABLE : begin
        // write pwdata to memory
        if (apb_slave.PSEL && apb_slave.PENABLE && apb_slave.PWRITE) begin
          mem[apb_slave.PADDR] <= apb_slave.PWDATA;
        end

        // return to SETUP
        apb_st <= SETUP;
      end

      R_ENABLE : begin
        // read apb_slave.PRDATA from memory
        if (apb_slave.PSEL && apb_slave.PENABLE && !apb_slave.PWRITE) begin
          apb_slave.PRDATA <= mem[apb_slave.PADDR];
        end

        // return to SETUP
        apb_st <= SETUP;
      end
    endcase
  end
end
endmodule
