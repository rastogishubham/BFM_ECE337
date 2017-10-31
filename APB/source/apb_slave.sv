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

logic [1:0] apb_st;
const logic [1:0] SETUP = 0;
const logic [1:0] W_ENABLE = 1;
const logic [1:0] R_ENABLE = 2;

// SETUP -> ENABLE
always @(negedge rst_n or posedge clk) begin
  if (rst_n == 0) begin
    apb_st <= 0;
    apb_slave.apbSlave.PRDATA <= 0;
  end

  else begin
    case (apb_st)
      SETUP : begin
        // clear the apb_slave.PRDATA
        apb_slave.apbSlave.PRDATA <= 0;

        // Move to ENABLE when the psel is asserted
        if (apb_slave.apbSlave.PSEL && !apb_slave.apbSlave.PENABLE) begin
          if (apb_slave.apbSlave.PWRITE) begin
            apb_st <= W_ENABLE;
          end

          else begin
            apb_st <= R_ENABLE;
          end
        end
      end

      W_ENABLE : begin
        // write pwdata to memory
        if (apb_slave.apbSlave.PSEL && apb_slave.apbSlave.PENABLE && apb_slave.apbSlave.PWRITE) begin
          mem[apb_slave.apbSlave.PADDR] <= apb_slave.apbSlave.PWDATA;
        end

        // return to SETUP
        apb_st <= SETUP;
      end

      R_ENABLE : begin
        // read apb_slave.PRDATA from memory
        if (apb_slave.apbSlave.PSEL && apb_slave.apbSlave.PENABLE && !apb_slave.apbSlave.PWRITE) begin
          apb_slave.apbSlave.PRDATA <= mem[apb_slave.apbSlave.PADDR];
        end

        // return to SETUP
        apb_st <= SETUP;
      end
    endcase
  end
end
endmodule
