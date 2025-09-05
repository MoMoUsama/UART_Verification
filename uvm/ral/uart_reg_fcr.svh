class uart_reg_fcr extends uvm_reg;

  uvm_reg_field EN_FIFO;     // bit 0 (ignored)
  uvm_reg_field CLR_RX_FIFO; // bit 1
  uvm_reg_field CLR_TX_FIFO; // bit 2
  uvm_reg_field IGNORED;     // bits [5:3]
  uvm_reg_field TRIG_LEVEL;  // bits [7:6]

  `uvm_object_utils(uart_reg_fcr)

  function new(string name = "fcr");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
    // Bit 0: Ignored (write-only, but no effect)
    EN_FIFO = uvm_reg_field::type_id::create("EN_FIFO");
    EN_FIFO.configure(.parent(this),
					  .size(1),    // n_bits
					  .lsb_pos(0),    // lsb_pos
					  .access("WO"), // access
					  .volatile(0),    // volatile
					  .reset(0),    // reset value
					  .has_reset(1),    // has_reset
					  .is_rand(0),    // is_rand
					  .individually_accessible(0)
    );

    // Bit 1: Clear Rx FIFO
    CLR_RX_FIFO = uvm_reg_field::type_id::create("CLR_RX_FIFO");
    CLR_RX_FIFO.configure(this,
      1,
      1,
      "WO", // write 1 clears
      0,
      0,
      1,
      0,
      0
    );

    // Bit 2: Clear Tx FIFO
    CLR_TX_FIFO = uvm_reg_field::type_id::create(.name("CLR_TX_FIFO"));
    CLR_TX_FIFO.configure(this,
      1,
      2,
      "WO", // write 1 clears
      0,
      0,
      1,
      0,
      0
    );

    // Bits [5:3]: Ignored
    IGNORED = uvm_reg_field::type_id::create(.name("IGNORED"));
    IGNORED.configure(this,
      3,
      3,
      "WO", // ignored but write-only per spec
      0,
      0,
      1,
      0,
      0
    );

    // Bits [7:6]: FIFO Trigger Level
    TRIG_LEVEL = uvm_reg_field::type_id::create(.name("TRIG_LEVEL"));
    TRIG_LEVEL.configure(this,
      2,
      6,
      "WO", // write-only
      0,
      3,    // reset = "11" (binary) → trigger level = 14 bytes
      1,
      0,
      0
    );
  endfunction
endclass
