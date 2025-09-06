`ifndef UVM_ANALYSIS_IMP_WB_DEFINED
`define UVM_ANALYSIS_IMP_WB_DEFINED
`uvm_analysis_imp_decl(_wb)
`endif

`ifndef UART_IMP_DECL_DEFINED
`define UART_IMP_DECL_DEFINED
`uvm_nonblocking_put_imp_decl(_driver)
`uvm_nonblocking_put_imp_decl(_monitor)
`endif


class uart_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(uart_scoreboard)

  uvm_analysis_imp_wb             #(wb_seq_item,   uart_scoreboard) wb_scb_imp;
  uvm_nonblocking_put_imp_driver  #(uart_seq_item, uart_scoreboard) rx_scb_imp;
  uvm_nonblocking_put_imp_monitor #(uart_seq_item, uart_scoreboard) tx_scb_imp;
  Env_Config                                                        env_conf;

  wb_seq_item THR_q[$];     // data to me transmitted
  wb_seq_item RBR_q[$];    //  Recieved data 
  uart_seq_item rx_q[$];       // data applied to RX Interface
  uart_seq_item tx_q[$];       // data collected from the TX interface

  // Constructor
  function new(string name = "uart_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    // Get config object (from test)
    if(!uvm_config_db#(Env_Config)::get(this, "", "env_conf", env_conf))
      `uvm_fatal("CFG", "env_conf not found in uvm_config_db")
	  
    wb_scb_imp = new("wb_scb_imp", this);
    rx_scb_imp = new("rx_scb_imp", this);
	tx_scb_imp = new("tx_scb_imp", this);
	
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction


  function bit can_put_driver();
	return 1;
  endfunction
    function bit can_put_monitor();
	return 1;
  endfunction
  
  function void write_wb(wb_seq_item t);
    if( !t.we && t.addr == 'd0 && !t.lcr[7]) begin //RBR
	  RBR_q.push_back(t);
      `uvm_info("SCOREBOARD write_wb()", $sformatf("@%0t: wb_seq_item Received \n %s",
                              $time/1ns, 
                              t.sprint()), 
                              UVM_MEDIUM);
							  
    end else if (t.we && t.addr == 'd0 && !t.lcr[7]) begin //THR_q
		THR_q.push_back(t);
        `uvm_info("SCOREBOARD write_wb()", $sformatf("@%0t: wb_seq_item Received \n %s",
                              $time/1ns, 
                              t.sprint()), 
                              UVM_MEDIUM);
	end
  endfunction

  function bit try_put_driver(uart_seq_item t);
		rx_q.push_back(t);
        `uvm_info("SCOREBOARD write_rx()", $sformatf("@%0t: uart_seq_item Received \n %s",
                              $time/1ns, 
                              t.sprint()), 
                              UVM_MEDIUM);
		return 1;
  endfunction
  
    function bit try_put_monitor(uart_seq_item t);
		tx_q.push_back(t);
        `uvm_info("SCOREBOARD write_tx()", $sformatf("@%0t: uart_seq_item Received \n %s",
                              $time/1ns, 
                              t.sprint()), 
                              UVM_MEDIUM);
		return 1;
  endfunction

  task run_phase(uvm_phase phase);
	bit empty=0;
    super.run_phase(phase);
    phase.raise_objection(this);
	`uvm_info("Scoreboard", $sformatf("@%0t: The SCB Started Working",$time/1ns), UVM_MEDIUM)
	fork
	
		begin //thread 1
			  match_and_compare_tx();
			  match_and_compare_rx();
		end
		begin //thread 2
			  forever begin
				if ( !empty && tx_q.size() == 0 && rx_q.size() == 0) begin// scoreboard queues empty
					  #(env_conf.wb_cycles_per_bit * env_conf.SYS_CLK_PERIOD * 16);
					  empty = 1;
				end
				else if ( tx_q.size() == 0 && rx_q.size() == 0) break;
			  end
		end
	join_any   
    `uvm_info("Scoreboard", $sformatf("@%0t: The SCB Objection Dropped",$time/1ns), UVM_MEDIUM)
    phase.drop_objection(this);
  endtask


  task match_and_compare_tx();
      uart_seq_item tx_item;
	  wb_seq_item   wb_item;
      forever begin
          // Wait until items arrive
          wait (tx_q.size() > 0 && THR_q.size() > 0);

          // Try to match transactions
          tx_item = tx_q.pop_front();
          wb_item = THR_q.pop_front();

          if(tx_item.has_stop_error) begin
            `uvm_error("Scoreboard matching TX", $sformatf("@%0t Stop error detected in scoreboard \n %s", $time/1ns, tx_item.sprint()))
          end else if(tx_item.has_parity_error) begin
            `uvm_error("Scoreboard matching TX", $sformatf("@%0t Parity error detected in scoreboard \n %s", $time/1ns, tx_item.sprint()))
          end else if(tx_item.data != wb_item.data)  begin
			`uvm_error("Scoreboard matching TX", $sformatf("@%0t data mismatch tx_item.data=%0h wb_item.data=%0h", $time/1ns, tx_item.data, wb_item.data))
          end 
		  
          if(tx_item.last_item || wb_item.last_item) break;
      end
  endtask

  // to match transactions by ID and perform comparison
  task match_and_compare_rx();
      uart_seq_item rx_item;
	  wb_seq_item   wb_item;
      forever begin
          // Wait until items arrive
          wait (rx_q.size() > 0 && THR_q.size() > 0);

          // Try to match transactions
          rx_item = rx_q.pop_front();
          wb_item = THR_q.pop_front();

          if(rx_item.has_stop_error) begin
            `uvm_info("Scoreboard matching RX", $sformatf("@%0t Injecting Stop error at the RX Interface \n %s", $time/1ns, rx_item.sprint()), UVM_MEDIUM)
          end else if(rx_item.has_parity_error) begin
            `uvm_info("Scoreboard matching RX", $sformatf("@%0t Injecting Parity error at the RX Interface  \n %s", $time/1ns, rx_item.sprint()), UVM_MEDIUM)
          end else if(rx_item.data != wb_item.data)  begin
			`uvm_info("Scoreboard matching RX", $sformatf("@%0t data mismatch rx_item.data=%0h wb_item.data=%0h", $time/1ns, rx_item.data, wb_item.data), UVM_MEDIUM)
          end 
		  
          if(rx_item.last_item || wb_item.last_item) break;
      end
  endtask

endclass: uart_scoreboard
