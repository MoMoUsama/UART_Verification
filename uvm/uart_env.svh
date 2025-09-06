class uart_env extends uvm_env;


  uart_wb_agent                    wb_agent;
  uart_agent                       u_agent;
  uart_reg_block                   ral_model;
  uvm_reg_predictor #(wb_seq_item) ral_predictor;
  Env_Config                       env_conf;
  uart_wb_reg_adapter              adapter;
  uart_scoreboard                  scoreboard;
  `uvm_component_utils(uart_env)

  function new(string name="uart_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction
	
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	$display("In the build Phase of the ENV");
	env_conf=Env_Config::type_id::create("env_conf");

    // Get config object (from test)
    if(!uvm_config_db#(Env_Config)::get(this, "", "env_conf", env_conf))
      `uvm_fatal("CFG", "env_conf not found in uvm_config_db")

		
	ral_model = uart_reg_block::type_id::create("ral_model", this);
	ral_model.configure(null, "");
	ral_model.build(); 
	
	adapter  = uart_wb_reg_adapter::type_id::create("wb_adapter", this);
	
	uvm_config_db#(uart_reg_block)::set(null, "", "ral_model", ral_model);
	uvm_config_db#(virtual wb_intf)::set(this, "wb_agent", "WB", env_conf.WB);
	
    // Build wb agent
    wb_agent = uart_wb_agent::type_id::create("wb_agent", this);
    ral_predictor = uvm_reg_predictor#(wb_seq_item)::type_id::create("ral_predictor", this);
	
    // Build uart agent
    u_agent = uart_agent::type_id::create("u_agent", this);
	uvm_config_db#(virtual tx_intf)::set(this, "u_agent", "TX", env_conf.TX);
	uvm_config_db#(virtual rx_intf)::set(this, "u_agent", "RX", env_conf.RX);
	
	//build scoreboard
	scoreboard = uart_scoreboard::type_id::create("scoreboard", this);
	
  endfunction

  function void connect_phase(uvm_phase phase);

	// wb agent connection
    wb_agent.mon.ap.connect(ral_predictor.bus_in);
	this.adapter.ral_model = this.ral_model;
    ral_predictor.map      = ral_model.default_map;
    ral_predictor.adapter  = this.adapter;
    ral_model.default_map.set_sequencer(wb_agent.seqr, ral_predictor.adapter);
	
	// scoreboard connections
	wb_agent.mon.ap.connect(scoreboard.wb_scb_imp);
	u_agent.drv.drv2scb_port.connect(scoreboard.rx_scb_imp);
	u_agent.mon.mon2scb_port.connect(scoreboard.tx_scb_imp);
  endfunction

endclass
