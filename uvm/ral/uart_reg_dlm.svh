class uart_reg_dlm extends uvm_reg;

  rand uvm_reg_field DLM_DATA;

  `uvm_object_utils(uart_reg_dlm)

  function new(string name = "dlm");
    super.new(name, 8, UVM_NO_COVERAGE); 
  endfunction

  virtual function void build();
    
    DLM_DATA = uvm_reg_field::type_id::create("DLM_DATA");
    DLM_DATA.configure(this, 8, 0, "RW", 0, 0, 1, 0, 0);
  endfunction
endclass
