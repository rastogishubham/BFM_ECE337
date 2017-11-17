`ifndef APB_TASKS_PKG_VH
`define APB_TASKS_PKG_VH

`include "definesPkg.vh"			// including Package definition

package apb_tasks_pkg;
	
	import definesPkg::*;				// Wildcard Import
	logic [APB_ADDR_WIDTH - 1: 0] PADDR;
	logic [APB_DATA_WIDTH - 1: 0] PWDATA;
	logic [APB_DATA_WIDTH - 1: 0] PRDATA;
	logic PSEL;
	logic PENABLE;
	logic PWRITE;

	task writeData(input logic apbClk, int unsigned addr, int unsigned data);
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

	task readData(input logic apbClk, int unsigned addr, output int unsigned data);
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

  	task idleTicks (input logic apbClk, input int tick);
    		repeat (tick) @(posedge apbClk);
  	endtask

	task initializeSignals();
		PSEL <= 1'b1;
		PWRITE <= 1'b0;
		PENABLE <= 1'b0;
	endtask: initializeSignals

	task clearSignals (input logic apbClk);
		PADDR   <= '0;
		PSEL    <= '0;
		PENABLE <= '0;
		PWRITE  <= '0;
		PWDATA  <= '0;
		//@(posedge apbClk);
  	endtask

  	task resetSignals (input logic apbClk, input logic rst);
    		wait (rst == 1'b0);
    		clearSignals(apbClk);
    		wait (rst == 1'b1);
  	endtask

  	task initialize (input logic apbClk);
    		clearSignals(apbClk);
    		/*fork
      		forever begin
        		resetSignals();
      		end
    		join_none*/
  	endtask
  endpackage
  `endif