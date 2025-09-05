class uart_reg_lcr extends uvm_reg;

  uvm_reg_field WORD_LEN;   // bits [1:0]
  uvm_reg_field STOP_BITS;  // bit 2
  uvm_reg_field PARITY_EN;  // bit 3
  uvm_reg_field EVEN_PARITY;// bit 4
  uvm_reg_field STICK_PARITY;// bit 5
  uvm_reg_field BREAK_CTRL; // bit 6
  uvm_reg_field DLAB;       // bit 7

  `uvm_object_utils(uart_reg_lcr)

  function new(string name = "lcr");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
    // Bits [1:0] : Word Length
    WORD_LEN = uvm_reg_field::type_id::create("WORD_LEN");
    WORD_LEN.configure(this,
      2,    // n_bits
      0,    // lsb_pos
      "RW", // access
      0,    // volatile
      3,    // reset value = 0b11 (8-bit word)
      1,    // has_reset
      0,    // is_rand
      0
    );

    // Bit 2 : Stop Bits
    STOP_BITS = uvm_reg_field::type_id::create("STOP_BITS");
    STOP_BITS.configure(this,
      1, 2, "RW", 0, 0, 1, 0, 0);

    // Bit 3 : Parity Enable
    PARITY_EN = uvm_reg_field::type_id::create("PARITY_EN");
    PARITY_EN.configure(this,
      1, 3, "RW", 0, 0, 1, 0, 0);

    // Bit 4 : Even Parity Select
    EVEN_PARITY = uvm_reg_field::type_id::create("EVEN_PARITY");
    EVEN_PARITY.configure(this,
      1, 4, "RW", 0, 0, 1, 0, 0);

    // Bit 5 : Stick Parity
    STICK_PARITY = uvm_reg_field::type_id::create("STICK_PARITY");
    STICK_PARITY.configure(this,
      1, 5, "RW", 0, 0, 1, 0, 0);

    // Bit 6 : Break Control
    BREAK_CTRL = uvm_reg_field::type_id::create("BREAK_CTRL");
    BREAK_CTRL.configure(this,
      1, 6, "RW", 0, 0, 1, 0, 0);

    // Bit 7 : Divisor Latch Access Bit (DLAB)
    DLAB = uvm_reg_field::type_id::create("DLAB");
    DLAB.configure(this,
      1, 7, "RW", 0, 0, 1, 0, 0);
  endfunction
endclass
