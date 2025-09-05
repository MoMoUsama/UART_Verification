package uart_ral_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include all register classes
  `include "uart_reg_lcr.svh"
  `include "uart_reg_lsr.svh"
  `include "uart_reg_fcr.svh"
  `include "uart_reg_rb.svh"
  `include "uart_reg_thr.svh"
  `include "uart_reg_iir.svh"
  `include "uart_reg_ier.svh"
  `include "uart_reg_dll.svh"
  `include "uart_reg_dlm.svh"
  `include "uart_reg_backdoor_policy.svh"
  `include "uart_reg_block.svh"
  
  
endpackage : uart_ral_pkg
