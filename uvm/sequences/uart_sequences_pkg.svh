package uart_sequences_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import Env_Config_pkg::*;
  import uart_wb_agent_pkg::*;
  import uart_agent_pkg::*;
  import uart_ral_pkg::*;
  
  `include "base_seq.svh"
  `include "uart_reg_access_seq.svh"
  `include "uart_simple_rx_seq.svh"
  `include "uart_tx_seq.svh"
  
endpackage : uart_sequences_pkg
