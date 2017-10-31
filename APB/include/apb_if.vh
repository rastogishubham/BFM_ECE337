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
	logic PREADY;

	default clocking apbtrans @(posedge apbClk);
		output PENABLE, PWRITE, PSEL, PADDR, PWDATA;
		input PREADY, PRDATA;
	endclocking

	clocking apbSlave @(posedge apbClk);
		input PENABLE, PWRITE, PSEL, PADDR, PWDATA;
		output PRDATA;
	endclocking

	modport tb	(
				clocking apbtrans, 
				import task writeData(), 
				import task readData(), 
				import task idleTicks(),
				import task initializeSignals(), 
				import task clearSignals(), 
				import task resetSignals(), 
				import task initialize()
			);
	modport slave(clocking apbSlave);

//class apb_bfm_inst extends apb_bfm;

	task writeData(int unsigned addr, int unsigned data);
		apbtrans.PSEL <= 1'b1;
		apbtrans.PWRITE <= 1'b1;
		apbtrans.PENABLE <= 1'b0;
		apbtrans.PADDR <= addr;
		apbtrans.PWDATA <= data;
		@(posedge apbClk);
		apbtrans.PENABLE <= 1'b1;
		@(posedge apbClk);
		apbtrans.PSEL <= 1'b0;
		apbtrans.PENABLE <= 1'b0;
	endtask: writeData

	task readData(int unsigned addr, output int unsigned data);
		apbtrans.PSEL <= 1'b1;
		apbtrans.PWRITE <= 1'b0;
		apbtrans.PENABLE <= 1'b0;
		apbtrans.PADDR <= addr;
		@(posedge apbClk);
		apbtrans.PENABLE <= 1'b1;
		@(posedge apbClk);
		@(posedge apbClk);
		
		@(posedge apbClk);
		data <= apbtrans.PRDATA;
		apbtrans.PSEL <= 1'b0;
		apbtrans.PENABLE <= 1'b0;
	endtask: readData

  	task idleTicks (input int tick);
    		repeat (tick) @(posedge apbClk);
  	endtask

	task initializeSignals();
		apbtrans.PSEL <= 1'b1;
		apbtrans.PWRITE <= 1'b0;
		apbtrans.PENABLE <= 1'b0;
	endtask: initializeSignals

	task clearSignals ();
		apbtrans.PADDR   <= '0;
    		apbtrans.PSEL    <= '0;
    		apbtrans.PENABLE <= '0;
    		apbtrans.PWRITE  <= '0;
    		apbtrans.PWDATA  <= '0;
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