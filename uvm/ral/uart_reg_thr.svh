class uart_reg_thr extends uvm_reg;

  uvm_reg_field DATA; 

  `uvm_object_utils(uart_reg_thr)

  function new(string name = "thr");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
  
    // the whole register [0:7] 
    DATA = uvm_reg_field::type_id::create(.name("DATA"));
    DATA.configure(.parent(this),
					  .size(8),    // n_bits
					  .lsb_pos(0),    // lsb_pos
					  .access("WO"), // access
					  .volatile(0),    // volatile
					  .reset(0),    // reset value
					  .has_reset(1),    // has_reset
					  .is_rand(0),    // is_rand
					  .individually_accessible(0));
  endfunction
endclass
