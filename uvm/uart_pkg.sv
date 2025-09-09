/* order matters*/


`include "./wb_agent/wb_intf.sv"
`include "./uart_agent/rx_intf.sv"
`include "./uart_agent/tx_intf.sv"
`include "./uart_agent/rx_intf.sv"
`include "modem_intf.sv"
`include "irq_intf.sv"
	
package uart_pkg;
	`include "uvm_macros.svh"
    import uvm_pkg::*;
	import Env_Config_pkg::*;
	import uart_ral_pkg::*;
	import uart_wb_agent_pkg::*;
	import uart_agent_pkg::*;
	import uart_sequences_pkg::*;
	
	
	`include "uart_scoreboard.svh"
	`include "uart_env.svh"
	`include "uart_virtual_sequence.svh"
    
endpackage: uart_pkg



