class uart_reg_block extends uvm_reg_block;

  // Handles for each register
  rand uart_reg_ier  IER;
  rand uart_reg_iir  IIR;
  rand uart_reg_lcr  LCR;
  rand uart_reg_lsr  LSR;
  rand uart_reg_fcr  FCR;
  rand uart_reg_rb   RB;
  rand uart_reg_thr  THR;
  rand uart_reg_dll  DLL;
  rand uart_reg_dlm  DLM;
  uart_reg_backdoor_policy bp ;

  `uvm_object_utils(uart_reg_block)

  function new(string name = "uart_reg_block");
    super.new(name, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
		// Create default map (base address 0x0, byte addressable, 1 bytes per word)
	  default_map = create_map(.name("default_map"), .base_addr('h0), .n_bytes(1), .endian(UVM_LITTLE_ENDIAN));
	  default_map.set_check_on_read(1);  //enable checking after each read

	  RB = uart_reg_rb::type_id::create("RB");
	  RB.configure(this, null, "RB");
	  RB.build();
	  default_map.add_reg(RB, 'd0, "RO");
	  
	  THR = uart_reg_thr::type_id::create("THR");
	  THR.configure(this, null, "THR");
	  THR.build();
	  default_map.add_reg(THR, 'd0, "WO");
	  
	  
	  IER = uart_reg_ier::type_id::create("IER");
	  IER.configure(this, null, "IER");
	  IER.build();
	  default_map.add_reg(IER, 'd1, "RW");

	  // Interrupt Identification Register (IIR) - address 0x2, RO
	  IIR = uart_reg_iir::type_id::create("IIR");
	  IIR.configure(this, null, "IIR");
	  IIR.build();
	  default_map.add_reg(IIR, 'd2, "RO");
	  
	  // FIFO Control Register (FCR) - address 0x2, WO
	  FCR = uart_reg_fcr::type_id::create("FCR");
	  FCR.configure(this, null, "FCR");
	  FCR.build();
	  default_map.add_reg(FCR, 'd2, "WO");

	  // Line Control Register (LCR) - address 0x3, RW
	  LCR = uart_reg_lcr::type_id::create("lcr");
	  LCR.configure(this, null, "lcr");
	  LCR.add_hdl_path_slice("lcr", 0, 8);
	  LCR.build();
	  default_map.add_reg(LCR, 'd3, "RW");


	  // Line Status Register (LSR) - address 0x5, RO
	  LSR = uart_reg_lsr::type_id::create("LSR");
	  LSR.configure(this, null, "LSR");
	  LSR.build();
	  default_map.add_reg(LSR, 'd5, "RO");
	  
	  //(DLL) - address 0xA, RW
	  DLL = uart_reg_dll::type_id::create("DLL");
	  DLL.configure(this, null, "DLL");
	  DLL.build();
	  default_map.add_reg(DLL, 'hA, "RW");
	  
	  // (DLM) - address 0xB, RW
	  DLM = uart_reg_dlm::type_id::create("DLM");
	  DLM.configure(this, null, "DLM");
	  DLM.build();
	  default_map.add_reg(DLM, 'hB, "RW");
	  
	  // Attach custom backdoor policy to the whole block
	  bp = uart_reg_backdoor_policy::type_id::create("bp");
	  this.set_backdoor(bp);
	  
	  this.add_hdl_path("top.DUT.regs", "RTL");
    // Lock to prevent further edits
    lock_model();
  endfunction

endclass