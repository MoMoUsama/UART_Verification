`timescale 1ns/1ps
`include "Intf.sv"
`include "Memory.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"
import pck::*;


module Top();
	bit clk;
	Intf intf_inst(clk);
	Memory DUT (intf_inst);

  initial begin
	forever #5 clk<=~clk;
  end
  
  
  /* instance name is uvm_test_top means the interface will be visible in the insyance that will be created automatically by uvm*/
  
  initial begin
	uvm_config_db#(virtual Intf)::set(null,"uvm_test_top","vif",intf_inst);
	run_test("Test");
  end
	
  initial begin
    $dumpfile("Top_tb.vcd");
    $dumpvars;
  end
  
endmodule
