class wb_seq_item extends uvm_sequence_item;
  //`uvm_object_utils(wb_seq_item)

  function new(string name="wb_seq_item");
		super.new(name); 
  endfunction
  
  
  // --------- Request ---------
  rand bit [31:0]     addr;          // byte address
  rand bit [31:0]     data;
  rand bit [3:0]      sel;           // byte enables
  rand int unsigned   pre_idle;      // cycles to wait before driving
  rand int unsigned   post_idle;     // cycles to wait after txn
  rand bit we;
  bit rst;

  // --------- Response ---------
  bit                 ack;           // got ACK
  time                start_ts, end_ts;

  constraint c_defaults {
    sel inside {4'h1,4'h3,4'hF};         // typical accesses; tweak as needed
    pre_idle  inside {[0:5]};
    post_idle inside {[0:5]};
  }



  `uvm_object_utils_begin(wb_seq_item)
    `uvm_field_int (addr,      UVM_ALL_ON)
    `uvm_field_int (data,     UVM_ALL_ON)
    `uvm_field_int (sel,       UVM_ALL_ON)
	`uvm_field_int (we,       UVM_ALL_ON)
	`uvm_field_int (rst,       UVM_ALL_ON)
    `uvm_field_int (pre_idle,  UVM_ALL_ON | UVM_NOPRINT)
    `uvm_field_int (post_idle, UVM_ALL_ON | UVM_NOPRINT)
    `uvm_field_int (ack,       UVM_ALL_ON | UVM_NOPACK)
  `uvm_object_utils_end
endclass
