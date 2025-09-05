class uart_reg_rb extends uvm_reg;

  uvm_reg_field RECIEVED_DATA; 

  `uvm_object_utils(uart_reg_rb)

  function new(string name = "rb");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
  
    // the whole register [0:7] 
    RECIEVED_DATA = uvm_reg_field::type_id::create(.name("RECIEVED_DATA"));
    RECIEVED_DATA.configure(.parent(this),
					  .size(8),    // n_bits
					  .lsb_pos(0),    // lsb_pos
					  .access("RO"), // access
					  .volatile(0),    // volatile
					  .reset(0),    // reset value
					  .has_reset(1),    // has_reset
					  .is_rand(0),    // is_rand
					  .individually_accessible(0));
  endfunction
endclass
