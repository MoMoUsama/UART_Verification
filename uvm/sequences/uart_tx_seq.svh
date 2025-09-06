class uart_tx_seq extends base_seq;
  `uvm_object_utils(uart_tx_seq)
   
  function new(string name = "uart_tx_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
	super.pre_body();
  endtask
  
  virtual task body();
	uvm_reg regs[$];
	
	`uvm_info("TX Seq", $sformatf("The no. of Registers in the RAL Model is %0d", regs.size()), UVM_LOW)
	
	if (!uvm_hdl_check_path("top.DUT.regs.lcr"))
	`uvm_fatal("PATH", "Backdoor path invalid for write")
	
	// 1. apply reset 
	apply_reset();
	program_lcr(env_conf.lcr, env_conf.dll);
		
	// 2. Heavy TX Sequence
    transmit();
	`uvm_info("TX_SEQ", "TX_SEQ Done", UVM_MEDIUM)
  endtask
	
	task transmit();
	  uvm_status_e   status;
	  uvm_reg_data_t tx_data;
	  int tx_transactions = 25;
	  localparam uvm_reg_data_t LAST_WORD = 8'hAA;
	  // Repeat random writes
	  repeat (tx_transactions) begin
		tx_data = $urandom_range(0, 255); // constrain to byte range
		ral_model.THR.write(status, tx_data, .parent(this));
		
		if (status != UVM_IS_OK) begin
		  `uvm_fatal("TX_SEQ_ERR", 
					 $sformatf("Failed to write 0x%0h to THR at time %0t", tx_data, $time/1ns))
		end
	  end

	  // Send a known pattern at the end for checking
	  ral_model.THR.write(status, LAST_WORD, .parent(this));

	  if (status != UVM_IS_OK) begin
		`uvm_fatal("TX_SEQ_ERR", 
				   $sformatf("Failed to write LAST_WORD (0x%0h) to THR at time %0t", LAST_WORD, $time/1ns))
	  end
	endtask

endclass: uart_tx_seq
