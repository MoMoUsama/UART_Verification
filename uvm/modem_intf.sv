interface modem_intf;

  logic RTS_PAD_O;  // Request To Send
  logic DTR_PAD_O;  // Data Terminal Ready
  logic CTS_PAD_I;  // Clear To Send
  logic DSR_PAD_I;  // Data Set Ready
  logic RI_PAD_I;   // Ring Indicator
  logic DCD_PAD_I;  // Data Carrier Detect
  
  
endinterface: modem_intf
