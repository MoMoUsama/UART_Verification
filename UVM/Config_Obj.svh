class Config_Obj extends uvm_object;
  `uvm_object_utils(Config_Obj)
  
  // Virtual interfaces
  virtual TX_IF tx_vif;
  virtual RX_IF rx_vif;
  bit [5:0] prescale;
  // Other configuration parameters
  bit has_tx_agent = 1;
  bit has_rx_agent = 1;
  bit has_scoreboard = 1;
  bit has_coverage = 1;
  
  // Constructor
  function new(string name = "Config_Obj");
    super.new(name);
  endfunction
  
endclass
