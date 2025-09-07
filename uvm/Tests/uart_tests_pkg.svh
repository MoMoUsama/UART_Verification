/* order matters*/
	
package uart_tests_pkg;
	`include "uvm_macros.svh"
    import uvm_pkg::*;
	import Env_Config_pkg::*;
	//import uart_sequences_pkg::*;
	`include "base_test.svh"
	`include "fastest_baud_test.svh"
	`include "slowest_baud_test.svh"
  
endpackage: uart_tests_pkg

