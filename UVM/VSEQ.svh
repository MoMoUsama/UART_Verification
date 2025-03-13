class VSEQ extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(VSEQ)
  
  
 	// Declare the sequences as members of the virtual sequence
	RX_Sequence rx_seq;
	TX_Sequence tx_seq;  
	
	// Handles for the target sequencers:
	Sequencer #(TX_Transaction) tx_sqr; 
	Sequencer #(RX_Transaction) rx_sqr;
	
  function new(string name = "VSEQ");
    super.new(name);
  endfunction
  
	task body(); 
	
		// Create the sequences
		rx_seq = RX_Sequence::type_id::create("rx_seq");
		tx_seq = TX_Sequence::type_id::create("tx_seq");
		
		//start them in parallel (UART is Full duplex )
		fork
		 rx_seq.start( rx_sqr , this );
		 tx_seq.start( tx_sqr , this );
		 join
	endtask
	
endclass: VSEQ