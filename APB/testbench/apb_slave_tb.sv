`include "definesPkg.vh"
`include "apb_tasks_pkg.vh"
`timescale 1ns / 10ps

import definesPkg::*;
import apb_tasks_pkg::*;

module apb_slave_tb;

	logic pclk;
	logic [7:0] addr;
	logic [31:0] data, rData;
	logic rstN;

	//apb_if apbBus(.apbClk(pclk), .rst(rstN));

  	logic        [APB_ADDR_WIDTH-1:0] PADDR;
  	logic                        PRWRITE;
  	logic                        PSEL;
  	logic                        PENABLE;
  	logic        [APB_DATA_WIDTH-1:0] PWDATA;
  	logic [APB_DATA_WIDTH-1:0] PRDATA;

	apb_slave DUT
	(
		.clk(pclk),
		.rst_n(rstN),
		.PADDR(PADDR),
		.PWRITE(PWRITE),
		.PSEL(PSEL),
		.PENABLE(PENABLE),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA)
	);


	//generate clock
	initial
	begin
		pclk = 1'b0;
		forever pclk = #(10 / 2) ~pclk;
	end

	//generate reset
	initial
	begin
		rstN = 1'b1;
		@(posedge pclk);
		rstN = 1'b0;
		@(posedge pclk);
		rstN = 1'b1;
		//initialize the APB bus for transactions
		initialize(pclk);
		//idleTicks(8);

		addr = 'h32;
		data = 'h10;
		//call tasks to write first and then read from the DUT
		writeData(pclk, addr, data);
		repeat(2) @(posedge pclk);
		readData(pclk, addr, rData);
		repeat(2) @(posedge pclk);
		assert(data == rData) $display("\nWrite then read test 1  passed");
    	assert(data != rData) $display("\nWrite then read test 1 failed");		
		data = 'h14;
		writeData(pclk, addr + 4, data);
		repeat(2) @(posedge pclk);
		readData(pclk, addr + 4, rData);
		repeat(2) @(posedge pclk);
		assert(data == rData) $display("\nWrite then read test 2 passed");
    	assert(data != rData) $display("\nWrite then read test 2 failed");
		data = 'h18;
		writeData(pclk, addr + 8, data);
		repeat(2) @(posedge pclk);
		readData(pclk, addr + 8, rData);
		repeat(2) @(posedge pclk);
		assert(data == rData) $display("\nWrite then read test 3 passed");
    	assert(data != rData) $display("\nWrite then read test 3 failed");
    	$finish;
	end
endmodule