class uart_polling_read_seq extends base_seq;
  `uvm_object_utils(uart_polling_read_seq)
   
  function new(string name = "uart_polling_read_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
	super.pre_body();
  endtask
  
  virtual task body();
	uvm_reg regs[$];
	
	`uvm_info("Polling Read Seq", $sformatf("The no. of Registers in the RAL Model is %0d", regs.size()), UVM_LOW)
	
	if (!uvm_hdl_check_path("top.DUT.regs.lcr") || !uvm_hdl_check_path("top.DUT.regs.lsr"))
	`uvm_fatal("PATH", "Backdoor path invalid for lsr or lcr")
	
	program_lcr(env_conf.lcr, env_conf.dll);
		
	//read RBR
    read();
	`uvm_info("UART_POLLING_READ_SEQ", "UART_POLLING_READ_SEQ Done", UVM_MEDIUM)
  endtask
	
	task read();
	  uvm_status_e   status;
	  uvm_reg_data_t lsr_data;
	  uvm_reg_data_t rbr_data;
	  time poll_delay;
	  time timeout_time ; // Example timeout, adjust as needed
	  time start_time = $time;

	  timeout_time = env_conf.SYS_CLK_PERIOD * env_conf.wb_cycles_per_bit * 24;
	  poll_delay = env_conf.SYS_CLK_PERIOD * env_conf.wb_cycles_per_bit * 8;

	  forever begin 
		if (($time - start_time) > timeout_time) begin
		  `uvm_info("POLLING_READ_READ_TASK", $sformatf("Timeout after %0t ns waiting for data", timeout_time), UVM_MEDIUM)
		  break;
		end

		ral_model.LSR.peek(status, lsr_data, .parent(this));
		if (status != UVM_IS_OK) begin
		  `uvm_fatal("POLLING_READ_ERR", "ERROR WHILE READING LSR")
		end

		if (lsr_data[0]) begin // There is new data in RBR
		  `uvm_info("POLLING_READ_READ_TASK", "Data detected in RBR", UVM_HIGH)
		  ral_model.RB.read(status, rbr_data, .parent(this)); // Frontdoor read

		  if (status == UVM_IS_OK) begin
			`uvm_info("POLLING_READ_READ_TASK", $sformatf("Successfully read data: 0x%0h", rbr_data), UVM_LOW)
			start_time = $time; // Reset timeout timer after a successful read
		  end else begin
			`uvm_error("POLLING_READ_ERR", "ERROR WHILE READING RBR")
		  end
		end 
		
		else begin // No new data in RBR
		  `uvm_info("POLLING_READ_READ_TASK", "No data in RBR, waiting...", UVM_HIGH)
		  #(poll_delay); 
		end
	  end 
	  
	endtask

endclass: uart_polling_read_seq
