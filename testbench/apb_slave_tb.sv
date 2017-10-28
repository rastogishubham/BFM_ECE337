`include "apbTasks.vh"
`include "definesPkg.vh"
import definesPkg::* ;				// Wildcard Import

`timescale 1ns / 10ps


module apb_slave_tb;

	logic pclk;
	logic [7:0] addr;
	logic [31:0] data, rData;
	logic [31:0] idleCycles;
	logic rstN;

	apb_if apbBus(.apbClk(pclk), .rst(rstN));

	apb_slave   DUT( .clk(pclk),
  					.rst_n(rstN),
  					.paddr(apbBus.PADDR),
  					.pwrite(apbBus.PWRITE),
  					.psel(apbBus.PSEL),
  					.penable(apbBus.PENABLE),
  					.pwdata(apbBus.PWDATA),
  					.prdata(apbBus.PRDATA)
				);

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
		repeat (5) @(posedge pclk);
		rstN = 1'b0;
		repeat (5) @(posedge pclk);
		rstN = 1'b1;
	end

	initial 	
	begin
		//initialize the APB bus for transactions
		apbBus.initialize();
		apbBus.idleTicks(100);

		addr = 'h32;
		data = 'h16;
		//call tasks to write first and then read from the DUT
		apbBus.writeData(2, 16);
		repeat(5) @(posedge pclk);
		apbBus.readData(2, rData);
		repeat(5) @(posedge pclk);
		apbBus.writeData(4, 32);
		repeat(5) @(posedge pclk);
		apbBus.readData(4, rData);
		repeat(5) @(posedge pclk);
		apbBus.writeData(8, 16);
		repeat(5) @(posedge pclk);
		apbBus.readData(8, rData);

		assert(data == rData) $display("\nWrite then read test passed");
    assert(data != rData) $display("\nWrite then read test failed");
    $finish;
	end
endmodule