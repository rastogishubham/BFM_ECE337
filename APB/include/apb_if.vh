`ifndef APB_IF_VH
`define APB_IF_VH

`include "definesPkg.vh"			// including Package definition
import definesPkg::*;				// Wildcard Import

interface apb_if(apbClk, rst);

	input logic apbClk;
	input logic rst;
	logic [APB_ADDR_WIDTH - 1: 0] PADDR;
	logic [APB_DATA_WIDTH - 1: 0] PWDATA;
	logic [APB_DATA_WIDTH - 1: 0] PRDATA;
	logic PSEL;
	logic PENABLE;
	logic PWRITE; //determines read or write transaction

	/*default clocking apbtrans @(posedge apbClk);
		output PENABLE, PWRITE, PSEL, PADDR, PWDATA;
		input PREADY, PRDATA;
	endclocking

	clocking apbSlave @(posedge apbClk);
		input PENABLE, PWRITE, PSEL, PADDR, PWDATA;
		output PRDATA;
	endclocking*/

	modport tb	(
				//clocking apbtrans, 
		import task writeData(), 
		import task readData(), 
		import task idleTicks(),
		import task initializeSignals(), 
		import task clearSignals(), 
		import task resetSignals(), 
		import task initialize(),
		output PENABLE, PWRITE, PSEL, PADDR, PWDATA,
		input PRDATA
			);
	modport slave(
		input PENABLE, PWRITE, PSEL, PADDR, PWDATA,
		output PRDATA
		);

//class apb_bfm_inst extends apb_bfm;

	task writeData(int unsigned addr, int unsigned data);
		PSEL <= 1'b1;
		PWRITE <= 1'b1;
		PENABLE <= 1'b0;
		PADDR <= addr;
		PWDATA <= data;
		@(posedge apbClk);
		PENABLE <= 1'b1;
		@(posedge apbClk);
		PSEL <= 1'b0;
		PENABLE <= 1'b0;
	endtask: writeData

	task readData(int unsigned addr, output int unsigned data);
		PSEL <= 1'b1;
		PWRITE <= 1'b0;
		PENABLE <= 1'b0;
		PADDR <= addr;
		@(posedge apbClk);
		PENABLE <= 1'b1;
		@(posedge apbClk);
		@(posedge apbClk);
		data <= PRDATA;
		@(posedge apbClk);
		PSEL <= 1'b0;
		PENABLE <= 1'b0;
	endtask: readData

  	task idleTicks (input int tick);
    		repeat (tick) @(posedge apbClk);
  	endtask

	task initializeSignals();
		PSEL <= 1'b1;
		PWRITE <= 1'b0;
		PENABLE <= 1'b0;
	endtask: initializeSignals

	task clearSignals ();
		PADDR   <= '0;
		PSEL    <= '0;
		PENABLE <= '0;
		PWRITE  <= '0;
		PWDATA  <= '0;
		@(posedge apbClk);
  	endtask

  	task resetSignals ();
    		wait (rst == 1'b0);
    		clearSignals();
    		wait (rst == 1'b1);
  	endtask

  	task initialize ();
    		clearSignals();
    		/*fork
      		forever begin
        		resetSignals();
      		end
    		join_none*/
  	endtask

//endclass

endinterface
`endif