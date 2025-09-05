class uart_reg_lsr extends uvm_reg;

  uvm_reg_field DR;     // Data Ready
  uvm_reg_field OE;     // Overrun Error
  uvm_reg_field PE;     // Parity Error
  uvm_reg_field FE;     // Framing Error
  uvm_reg_field BI;     // Break Interrupt
  uvm_reg_field THRE;   // Transmit FIFO Empty
  uvm_reg_field TEMT;   // Transmitter Empty
  uvm_reg_field ERR;    // Error in RX FIFO

  `uvm_object_utils(uart_reg_lsr)

  function new(string name = "lsr");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
    // Bit 0 : Data Ready
    DR = uvm_reg_field::type_id::create("DR");
    DR.configure(this,
      1, 0, "RO", 0, 0, 1, 0, 0);

    // Bit 1 : Overrun Error
    OE = uvm_reg_field::type_id::create("OE");
    OE.configure(this,
      1, 1, "RO", 0, 0, 1, 0, 0);

    // Bit 2 : Parity Error
    PE = uvm_reg_field::type_id::create("PE");
    PE.configure(this,
      1, 2, "RO", 0, 0, 1, 0, 0);

    // Bit 3 : Framing Error
    FE = uvm_reg_field::type_id::create("FE");
    FE.configure(this,
      1, 3, "RO", 0, 0, 1, 0, 0);

    // Bit 4 : Break Interrupt
    BI = uvm_reg_field::type_id::create("BI");
    BI.configure(this,
      1, 4, "RO", 0, 0, 1, 0, 0);

    // Bit 5 : Transmit FIFO Empty
    THRE = uvm_reg_field::type_id::create("THRE");
    THRE.configure(this,
      1, 5, "RO", 0, 0, 1, 0, 0); // reset = 1 (FIFO empty at reset)

    // Bit 6 : Transmitter Empty
    TEMT = uvm_reg_field::type_id::create("TEMT");
    TEMT.configure(this,
      1, 6, "RO", 0, 0, 1, 0, 0); // reset = 1 (TX empty at reset)

    // Bit 7 : Error in RX FIFO
    ERR = uvm_reg_field::type_id::create("ERR");
    ERR.configure(this,
      1, 7, "RO", 0, 0, 1, 0, 0);
  endfunction
endclass
