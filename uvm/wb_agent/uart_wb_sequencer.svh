class uart_wb_sequencer extends uvm_sequencer #(wb_seq_item);
  `uvm_component_utils(uart_wb_sequencer)
  function new(string name="uart_wb_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction
endclass
