class uart_reg_access_seq extends base_seq;
  `uvm_object_utils(uart_reg_access_seq)
   
  function new(string name = "uart_reg_access_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
	super.pre_body();
  endtask
  
  virtual task body();
	uvm_reg regs[$];
	
	`uvm_info("Register Access Seq", $sformatf("The no. of Registers in the RAL Model is %0d", regs.size()), UVM_LOW)
	
	if (!uvm_hdl_check_path("top.DUT.regs.lcr"))
	`uvm_fatal("PATH", "Backdoor path invalid for write")

	program_lcr(env_conf.lcr, env_conf.dll);
		
	// 2. reg access
	read();
	`uvm_info("REG_ACCESS_SEQ", "REG_ACCESS_SEQ Done", UVM_MEDIUM)
  endtask
  
    task read();
		uvm_status_e status;
		uvm_reg_data_t data;
		uvm_reg regs[$];
	    bit has_read_access = 1;
		uvm_reg_field fields[$];
		bit [7:0] val;
		ral_model.default_map.get_registers(regs);
		
		foreach (regs[i]) begin
		
		  if(regs[i].get_name()=="DLL" || regs[i].get_name()=="DLM") begin
				ral_model.LCR.peek(status, val, .parent(this));
				ral_model.LCR.poke(status, {1, val[6:0]}, .parent(this));
				ral_model.LCR.peek(status, data, .parent(this));
				if(data !=  {1, val[6:0]})
					`uvm_fatal("BACKDOOR ACCESS ERR", "Peek read wrong value")
		  end
		  
		  else begin
			ral_model.LCR.poke(status, this.env_conf.lcr,  .parent(this));
			ral_model.LCR.peek(status, data, .parent(this));
				if(data != this.env_conf.lcr)
					`uvm_fatal("BACKDOOR ACCESS ERR", "Peek read wrong value")
		  end
		  
		  regs[i].get_fields(fields);
		  foreach (fields[j]) begin
			string acc = fields[j].get_access();
			if (acc == "WO") begin
			  has_read_access = 0;
			  break;
			end
		  end

		  if (has_read_access) begin
			uvm_status_e status;
			uvm_reg_data_t data;

			regs[i].read(status, data, .parent(this));
			`uvm_info(get_type_name(),
					  $sformatf("Read %s = 0x%0h (expected 0x%0h)",
								regs[i].get_name(), data, regs[i].get_mirrored_value()),
					  UVM_LOW)
		  end
		end
    endtask
endclass: uart_reg_access_seq
