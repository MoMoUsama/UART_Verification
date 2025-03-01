class Config_Obj extends uvm_object;
  `uvm_object_utils(Config_Obj)
  
  // Virtual interfaces
  virtual TX_IF TXRXvif;
  virtual TX_IF rx_vif;
  
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