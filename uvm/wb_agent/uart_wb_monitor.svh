class uart_wb_monitor extends uvm_monitor;

  virtual wb_intf vif;
  uvm_analysis_port#(wb_seq_item) ap;
    Env_Config env_conf;
	
  `uvm_component_utils(uart_wb_monitor)

  function new(string name="uart_wb_monitor", uvm_component parent=null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    if(!uvm_config_db#(virtual wb_intf)::get(this, "", "WB", vif))
      `uvm_fatal("NOVIF", "No virtual interface set for uart_wb_monitor");
	  
	//env_conf = Env_Config::type_id::create("env_conf");
    if(!uvm_config_db#(Env_Config)::get(this, "", "env_conf", env_conf))
      `uvm_fatal("No env_conf", "No env_conf set in DB for wb_monitor");
  
  endfunction
  
  
  task run_phase(uvm_phase phase);
    wb_seq_item tr;
    forever begin
        @(posedge vif.WB_ACK);
		tr 	     = wb_seq_item::type_id::create("tr");
		tr.addr  = vif.WB_ADDR;
		tr.we    = vif.WB_WE;
		tr.data  = (vif.WB_WE) ? vif.WB_DAT_I : vif.WB_DAT_O;
		tr.ack = 1;
		tr.lcr = env_conf.lcr;
		ap.write(tr);
		`uvm_info("Monitor", $sformatf("Transaction passed from the monitor \n %s", tr.sprint()), UVM_MEDIUM)
    end
  endtask
endclass
