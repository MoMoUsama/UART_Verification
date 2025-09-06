class uart_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(uart_virtual_sequence)
  
  
 	// Declare all the sequences 
	uart_reg_access_seq      reg_access_seq; 
	uart_simple_rx_seq       simple_rx_seq;
	uart_tx_seq              tx_seq;
	
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
		
		
		// 2. check sequebcer handles
		if(wb_sqr==null)   `uvm_fatal("Virtual Sequence", "wb_sequencer is NULL")                
		if(uart_sqr==null) `uvm_fatal("Virtual Sequence", "uart_sequencer is NULL")    

		//3. Now orchestrate sequences on the sequencers as u want 
		//fork
			reg_access_seq.start( wb_sqr, this);
			tx_seq.start( wb_sqr, this);
			simple_rx_seq.start ( uart_sqr, this);
		//join
	endtask
	
endclass: uart_virtual_sequence