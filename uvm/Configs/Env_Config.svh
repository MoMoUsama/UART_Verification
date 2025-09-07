class Env_Config extends uvm_object;
  `uvm_object_utils(Env_Config)
  
  // Virtual interfaces
  virtual tx_intf TX;
  virtual rx_intf RX;
  virtual irq_intf IRQ;
  virtual modem_intf MODEM;
  virtual wb_intf WB;
  
  // Other configuration parameters
  bit [7:0] lcr;    // test-specific configuration
  bit [15:0] dll;  //  test specific baud-rate
  int wb_cycles_per_bit;
  bit inject_parity_err;
  bit inject_stop_err;
  
  bit has_uart_agent = 1;
  bit has_wb_agent = 1;
  bit has_scoreboard = 1;
  bit has_coverage = 1;
  int SYS_CLK_PERIOD;
  int tx_transactions;
  int rx_transactions;
  
  // Constructor
  function new(string name = "Env_Config");
    super.new(name);
  endfunction
  
endclass: Env_Config
