class uart_reg_dll extends uvm_reg;

  rand uvm_reg_field DLL_DATA;

  `uvm_object_utils(uart_reg_dll)

  function new(string name = "dll");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
    
    DLL_DATA = uvm_reg_field::type_id::create("DLL_DATA");
    DLL_DATA.configure(this, 8, 0, "RW", 0, 0, 1, 0, 0);
  endfunction
endclass
