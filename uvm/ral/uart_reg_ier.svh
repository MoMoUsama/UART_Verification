class uart_reg_ier extends uvm_reg;

  rand uvm_reg_field RDA_INT_EN;   // bit 0: Received Data Available interrupt enable
  rand uvm_reg_field THRE_INT_EN;  // bit 1: Transmitter Holding Register Empty interrupt enable
  rand uvm_reg_field RLS_INT_EN;   // bit 2: Receiver Line Status interrupt enable
  rand uvm_reg_field MS_INT_EN;    // bit 3: Modem Status interrupt enable
       uvm_reg_field RESERVED;     // bits [7:4] Reserved, should read 0

  `uvm_object_utils(uart_reg_ier)

  function new(string name = "ier");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
    // Bit 0
    RDA_INT_EN = uvm_reg_field::type_id::create("RDA_INT_EN");
    RDA_INT_EN.configure(this, 1, 0, "RW", 0, 0, 1, 0, 0);

    // Bit 1
    THRE_INT_EN = uvm_reg_field::type_id::create("THRE_INT_EN");
    THRE_INT_EN.configure(this, 1, 1, "RW", 0, 0, 1, 0, 0);

    // Bit 2
    RLS_INT_EN = uvm_reg_field::type_id::create("RLS_INT_EN");
    RLS_INT_EN.configure(this, 1, 2, "RW", 0, 0, 1, 0, 0);

    // Bit 3
    MS_INT_EN = uvm_reg_field::type_id::create("MS_INT_EN");
    MS_INT_EN.configure(this, 1, 3, "RW", 0, 0, 1, 0, 0);

    // Bits [7:4] Reserved, read as 0
    RESERVED = uvm_reg_field::type_id::create("RESERVED");
    RESERVED.configure(this, 4, 4, "RW", 0, 0, 1, 0, 0);
  endfunction
endclass
