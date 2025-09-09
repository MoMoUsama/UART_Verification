package uart_tests_pkg;

  // UVM base
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Import the full UART environment (env, agents, ral, sequences…)
  import uart_pkg::*;
  import Env_Config_pkg::*;
  import uart_sequences_pkg::*;
  
  // Test classes
  `include "base_test.svh"
  `include "fastest_baud_test.svh"
  `include "slowest_baud_test.svh"

endpackage : uart_tests_pkg
