class uart_reg_iir extends uvm_reg;

  uvm_reg_field INT_PENDING;  // Bit 0
  uvm_reg_field INT_ID;       // Bits [3:1]
  uvm_reg_field RESERVED;     // Bits [5:4], always 0
  uvm_reg_field COMPAT;       // Bits [7:6], always 1

  `uvm_object_utils(uart_reg_iir)

  function new(string name = "iir");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
    // Bit 0: Interrupt Pending (Read-Only)
    INT_PENDING = uvm_reg_field::type_id::create("INT_PENDING");
    INT_PENDING.configure(this,
      1,   // n_bits
      0,   // lsb_pos
      "RO",// access
      0,   // volatile
      1,   // reset value = 1 (from reset = 0xC1) -> the bit is defined as active low, "no interrupt" corresponds to logic 1.
      1,   // has_reset
      0,   // is_rand
      0    // individually accessible
    );

    // Bits [3:1]: Interrupt ID (Read-Only)
    INT_ID = uvm_reg_field::type_id::create("INT_ID");
    INT_ID.configure(this,
      3,   // n_bits
      1,   // lsb_pos
      "RO",
      0,
      0,   // reset value = 000 (from reset = 0xC1)
      1,
      0,
      0
    );

    // Bits [5:4]: Reserved, always 0
    RESERVED = uvm_reg_field::type_id::create("RESERVED");
    RESERVED.configure(this,
      2,
      4,
      "RO",
      0,
      0,   // reset = 00
      1,
      0,
      0
    );

    // Bits [7:6]: Compatibility bits, always 1
    COMPAT = uvm_reg_field::type_id::create("COMPAT");
    COMPAT.configure(this,
      2,
      6,
      "RO",
      0,
      3,   // binary "11"
      1,
      0,
      0
    );
  endfunction
endclass
