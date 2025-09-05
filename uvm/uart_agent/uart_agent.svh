class uart_agent extends uvm_agent;

  uart_driver       drv;
  uart_sequencer    seqr;
  uart_monitor      mon;
  virtual tx_intf   tx_vif;
  virtual rx_intf   rx_vif;
  uvm_analysis_port #(uart_seq_item) analysis_port;
  
  
  `uvm_component_utils(uart_agent)

  function new(string name="uart_agent", uvm_component parent=null);
    super.new(name, parent);
	analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    // Get vif
    if(!uvm_config_db#(virtual tx_intf)::get(this, "", "TX", tx_vif))
      `uvm_fatal("uart_agent cannot founf tx_vif", "TX Interface not found in uvm_config_db")
	  
    if(!uvm_config_db#(virtual rx_intf)::get(this, "", "RX", rx_vif))
      `uvm_fatal("uart_agent cannot founf rx_vif", "RX Interface not found in uvm_config_db")
	  
	  
      drv  = uart_driver   ::type_id::create("drv", this);
      seqr = uart_sequencer::type_id::create("seqr", this);
	  mon = uart_monitor   ::type_id::create("mon", this);
	  
	  uvm_config_db#(virtual tx_intf)::set(this, "mon", "TX", tx_vif);
	  uvm_config_db#(virtual rx_intf)::set(this, "drv", "RX", rx_vif);
	  
  endfunction

  function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
	  mon.ap.connect(analysis_port);
  endfunction
endclass
