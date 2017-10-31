`include "apb_if.vh"
`include "definesPkg.vh"
import definesPkg::* ;				// Wildcard Import

`timescale 1ns / 10ps


module apb_slave_tb;

	logic pclk;
	logic [7:0] addr;
	logic [31:0] data, rData;
	//logic [31:0] idleCycles;
	logic rstN;

	apb_if apbBus(.apbClk(pclk), .rst(rstN));

	apb_slave DUT(pclk, rstN, apbBus);

	//typedef virtual apb_if #(32, 32).tb apbTb;
	//apbTb apbMaster;
	//apbMaster = apbTb(apb_t);
	//apbMaster = apb_t;
	//typedef virtual amba3_apb_if #(32, 32).apbtrans apbMaster;
	//apbMaster = apb_if_inst;

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
		apbBus.tb.initialize();
		//apbBus.idleTicks(8);

		addr = 'h32;
		data = 'h10;
		//call tasks to write first and then read from the DUT
		apbBus.writeData(addr, data);
		repeat(2) @(posedge pclk);
		apbBus.readData(addr, rData);
		repeat(2) @(posedge pclk);
		assert(data == rData) $display("\nWrite then read test 1  passed");
    	assert(data != rData) $display("\nWrite then read test 1 failed");		
		data = 'h14;
		apbBus.writeData(addr + 4, data);
		repeat(2) @(posedge pclk);
		apbBus.readData(addr + 4, rData);
		repeat(2) @(posedge pclk);
		assert(data == rData) $display("\nWrite then read test 2 passed");
    	assert(data != rData) $display("\nWrite then read test 2 failed");
		data = 'h18;
		apbBus.writeData(addr + 8, data);
		repeat(2) @(posedge pclk);
		apbBus.readData(addr + 8, rData);
		repeat(2) @(posedge pclk);
		assert(data == rData) $display("\nWrite then read test 3 passed");
    	assert(data != rData) $display("\nWrite then read test 3 failed");
    	$finish;
	end
endmodule