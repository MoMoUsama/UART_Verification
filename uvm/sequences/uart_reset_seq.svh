class uart_reset_seq extends base_seq;
  `uvm_object_utils(uart_reset_seq)
   
  function new(string name = "uart_reset_seq");
    super.new(name);
  endfunction
  
  virtual task body();
	uvm_reg regs[$];
	
	`uvm_info("uart_reset_seq", $sformatf("Starting the Body of the RESET Sequence"), UVM_LOW)
	
	apply_reset();
		
	`uvm_info("uart_reset_seq", "uart_reset_seq Done", UVM_MEDIUM)
  endtask
  
	task apply_reset(); //doesn't go through the RAL Adapter
		wb_seq_item req;
		`uvm_info(get_type_name(), "Applying Reset...", UVM_MEDIUM)

		// Assert reset
		req = wb_seq_item::type_id::create("req");
		req.rst = 1;
		start_item(req);
		finish_item(req);
		ral_model.reset();
		`uvm_info(get_type_name(), "", UVM_MEDIUM)
	endtask
endclass: uart_reset_seq
