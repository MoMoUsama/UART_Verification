class uart_seq_item extends uvm_sequence_item;

  function new(string name="uart_seq_item");
		super.new(name); 
  endfunction
  
  
  // --------- Request ---------
  rand bit [7:0]     data;
  bit parity;
  bit stop;
  bit has_stop_error;
  bit has_parity_error;
  bit last_item;

  `uvm_object_utils_begin(uart_seq_item)
    `uvm_field_int (data,      UVM_ALL_ON)
    `uvm_field_int (parity,     UVM_ALL_ON)
	`uvm_field_int (stop,     UVM_ALL_ON)
	`uvm_field_int (has_parity_error,     UVM_ALL_ON)
	`uvm_field_int (has_stop_error,     UVM_ALL_ON)
	`uvm_field_int (last_item,     UVM_ALL_ON)
  `uvm_object_utils_end
endclass
