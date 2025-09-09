class uart_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(uart_virtual_sequence)
  
  
 	// Declare all the sequences 
	uart_reg_access_seq      reg_access_seq; 
	uart_simple_rx_seq       simple_rx_seq;
	uart_tx_seq              tx_seq;
	uart_reset_seq           reset_seq;
	uart_polling_read_seq    polling_read_seq;
	uart_simple_rx_seq       simple_rx_seq2;
	
	// Handles for the target sequencers:
	uart_wb_sequencer wb_sqr; 
	uart_sequencer    uart_sqr;
	
  function new(string name = "uart_virtual_sequence");
    super.new(name);
  endfunction
  
	task body(); 

		// 1. Apply reset to DUT & RAL
		reg_access_seq = uart_reg_access_seq::type_id::create("reg_access_seq");
		simple_rx_seq = uart_simple_rx_seq::type_id::create("simple_rx_seq");
		tx_seq = uart_tx_seq::type_id::create("tx_seq");
		reset_seq = uart_reset_seq::type_id::create("reset_seq");
		polling_read_seq = uart_polling_read_seq::type_id::create("polling_read_seq");
		
		// 2. check sequebcer handles
		if(wb_sqr  ==null)   `uvm_fatal("Virtual Sequence", "wb_sequencer is NULL")                
		if(uart_sqr==null) `uvm_fatal("Virtual Sequence", "uart_sequencer is NULL")    


		reset_seq.start( wb_sqr, this); //reset
		reg_access_seq.start( wb_sqr, this);
		fork
			polling_read_seq.start(wb_sqr, this);
			simple_rx_seq.start (uart_sqr, this);
		join
		
		
		simple_rx_seq2 = uart_simple_rx_seq::type_id::create("simple_rx_seq2");
		`uvm_info("Virtual Sequence", $sformatf("@%0t First Fork Done", $time/1ns), UVM_MEDIUM)
		//reset_seq.start( wb_sqr, this); //reset
		fork
			tx_seq.start(wb_sqr, this);
			simple_rx_seq2.start ( uart_sqr, this);
		join
	endtask
	
	task check_sequencers_availability();
	
			if (!wb_sqr.has_do_available())
			  `uvm_info("SQRCHK", "WB Sequencer is idle", UVM_LOW)
			  `uvm_warning("SQRCHK", "WB Sequencer still in Use!")
			  
			if (!uart_sqr.has_do_available())
			  `uvm_info("SQRCHK", "UART Sequencer is idle", UVM_LOW)
			else
			  `uvm_warning("SQRCHK", "UART Sequencer still in Use!")
	endtask
	
endclass: uart_virtual_sequence