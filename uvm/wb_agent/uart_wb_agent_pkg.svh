package uart_wb_agent_pkg;

  import uvm_pkg::*;
  import uart_ral_pkg::*;
  import Env_Config_pkg::*;
  `include "uvm_macros.svh"

  `include "wb_seq_item.svh"
  `include "uart_wb_reg_adapter.svh"
  `include "uart_wb_driver.svh"
  `include "uart_wb_monitor.svh"
  `include "uart_wb_sequencer.svh"
  `include "uart_wb_agent.svh"
  
endpackage : uart_wb_agent_pkg
