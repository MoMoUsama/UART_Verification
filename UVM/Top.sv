`timescale 1ns/1ps
import uvm_pkg::*; 
`include "uvm_macros.svh" 
import pck::*;

module Top();
	logic clk, prescaled_clk;
  bit [5:0] prescale = 6'd4;
  parameter UART_CLK_PERIOD = 'd40;

	TX_IF TX_intf_inst(clk);
	RX_IF RX_intf_inst(prescaled_clk);
	Config_Obj conf;

    // Instantiate the DUT
    UART dut(
        .TX_clk        (TX_intf_inst.clk),
		    .rst		       (TX_intf_inst.rst),
        .data_valid    (TX_intf_inst.data_valid),
        .P_DATA        (TX_intf_inst.P_DATA),
        .TX_OUT        (TX_intf_inst.TX_OUT),
		    .BUSY          (TX_intf_inst.BUSY),
		    .par_en        (TX_intf_inst.par_en),
		    .par_type      (TX_intf_inst.par_type),
		
		
		    .RX_clk        (RX_intf_inst.clk),
        .RX_out_valid  (RX_intf_inst.RX_out_valid),
        .RX_IN         (RX_intf_inst.RX_IN),
		    .prescale      (RX_intf_inst.prescale),
        .RX_OUT        (RX_intf_inst.RX_OUT),
		    .parity_err    (RX_intf_inst.parity_err),
		    .stp_err       (RX_intf_inst.stop_err)
		
    );

  initial begin
    clk='d0;
	forever #(UART_CLK_PERIOD/2) clk<=~clk;
  end
  
  initial begin
    prescaled_clk = 'd0;
	forever #(UART_CLK_PERIOD/(prescale*2)) prescaled_clk<=~prescaled_clk;
  end
  
  /* instance name is uvm_test_top means the interface will be visible in the instance that will be created automatically by uvm*/
  
  initial begin
	conf = Config_Obj::type_id::create("conf");
	conf.tx_vif = TX_intf_inst;
	conf.rx_vif = RX_intf_inst;
  conf.prescale = prescale;
	uvm_config_db#(Config_Obj)::set(null,"uvm_test_top","conf",conf);
	run_test("Test");
  end
	
  initial begin
    $dumpfile("Top_tb.vcd");
    $dumpvars;
  end
  
endmodule
