`timescale 1ns/1ps
`include "./wb_agent/wb_intf.sv"
import uvm_pkg::*; 
import uart_tests_pkg::*;

module top();

	/////////////////   clock  generator  ///////////////////
	parameter WBCLK_PEREIOD = 20; 
	logic WBCLK;
	initial begin
		WBCLK = 'd0;
		forever WBCLK = #(WBCLK_PEREIOD) ~WBCLK;
	end
	
	/////////////////   Interfaces  ///////////////////
	wb_intf WB(.WBCLK(WBCLK));
	tx_intf TX(.WBCLK(WBCLK));
	rx_intf RX(.WBCLK(WBCLK));
	irq_intf IRQ();
	modem_intf MODEM();
	
	
	/////////////////   DUT  ///////////////////
	uart_top DUT (
		.wb_clk_i(WBCLK),
		.wb_rst_i(WB.WBRST),
		.wb_adr_i(WB.WB_ADDR),
		.wb_dat_i(WB.WB_DAT_I),
		.wb_dat_o(WB.WB_DAT_O),
		.wb_we_i(WB.WB_WE),
		.wb_stb_i(WB.WB_STB),
		.wb_cyc_i(WB.WB_CYC),
		.wb_ack_o(WB.WB_ACK),
		.wb_sel_i(WB.WB_SEL),
		
		// interrupt sirnal
		.int_o(IRQ.INT_O),
		
		// RX Serial Input
		.srx_pad_i(RX.SRX_PAD_I),
		
		// TX serial Output
		.stx_pad_o(TX.STX_PAD_O),
		
		// Modem control signals
		.rts_pad_o (MODEM.RTS_PAD_O),
		.cts_pad_i (MODEM.CTS_PAD_I),
		.dtr_pad_o (MODEM.DTR_PAD_O),
		.dsr_pad_i (MODEM.DSR_PAD_I),
		.ri_pad_i  (MODEM.RI_PAD_I),
		.dcd_pad_i (MODEM.DCD_PAD_I),
		.baud_o(TX.BAUD_O) //optional 
	);
	
	
	initial begin
		uvm_config_db #(virtual wb_intf)   ::set(null, "uvm_test_top", "WB", WB);
		uvm_config_db #(virtual tx_intf)   ::set(null, "uvm_test_top", "TX", TX);
		uvm_config_db #(virtual rx_intf)   ::set(null, "uvm_test_top", "RX", RX);
		uvm_config_db #(virtual irq_intf)  ::set(null, "uvm_test_top", "IRQ", IRQ);
		uvm_config_db #(virtual modem_intf)::set(null, "uvm_test_top", "MODEM", MODEM);
		uvm_config_db #(int)::set(null, "uvm_test_top", "SYS_CLK", WBCLK_PEREIOD*1ns);
		run_test("fastest_baud_test");
	end


	
endmodule 