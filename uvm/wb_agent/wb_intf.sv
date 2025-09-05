interface wb_intf(input WBCLK);

  logic [2:0]  WB_ADDR;   // or [2:0] depending on configuration
  logic [3:0]  WB_SEL;
  logic [7:0] WB_DAT_I;  // Data input
  logic [7:0] WB_DAT_O;  // Data output
  logic        WB_WE;     // Write enable
  logic        WB_STB;    // Strobe signal (valid transfer)
  logic        WB_CYC;    // Indicates bus cycle in progress
  logic        WB_ACK;    // Acknowledge signal
  logic 	   WBRST;
  
  
endinterface: wb_intf
