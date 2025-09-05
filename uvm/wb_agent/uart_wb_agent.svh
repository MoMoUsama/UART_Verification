class uart_wb_agent extends uvm_agent;

  uart_wb_driver    drv;
  uart_wb_sequencer seqr;
  uart_wb_monitor   mon;
  virtual wb_intf   vif;
  
  
  `uvm_component_utils(uart_wb_agent)

  function new(string name="uart_wb_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    // Get vif
    if(!uvm_config_db#(virtual wb_intf)::get(this, "", "WB", vif))
      `uvm_fatal("WB_AGENT cannot founf vif", "WB Interface not found in uvm_config_db")
	  
	  
      drv  = uart_wb_driver   ::type_id::create("drv", this);
      seqr = uart_wb_sequencer::type_id::create("seqr", this);
	  mon = uart_wb_monitor   ::type_id::create("mon", this);
	  
	  uvm_config_db#(virtual wb_intf)::set(this, "mon", "WB", vif);
	  uvm_config_db#(virtual wb_intf)::set(this, "drv", "WB", vif);
	  
  endfunction

  function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
