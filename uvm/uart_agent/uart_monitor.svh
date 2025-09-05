class uart_monitor extends uvm_monitor;

  virtual tx_intf vif;
  uvm_analysis_port#(uart_seq_item) ap;
  Env_Config                       env_conf;
  
  `uvm_component_utils(uart_monitor)

  function new(string name="uart_monitor", uvm_component parent=null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    if(!uvm_config_db#(virtual tx_intf)::get(this, "", "TX", vif))
      `uvm_fatal("NOVIF", "No virtual interface set for uart_monitor");
	  
	env_conf = Env_Config::type_id::create("env_conf");
    if(!uvm_config_db#(Env_Config)::get(this, "", "env_conf", env_conf))
      `uvm_fatal("No env_conf", "No env_conf set in DB for uart_monitor");
	  
  endfunction
  
  
  task run_phase(uvm_phase phase);
    uart_seq_item item;
	int n_bits, i;
	real stop_bits; 
	bit parity_en         = this.env_conf.lcr[3]; 
	int wb_cycles_per_bit = this.env_conf.wb_cycles_per_bit;
	bit expected_parity;
	logic [7:0] mask;
	
	case(this.env_conf.lcr[1:0])
		2'b00: n_bits = 5;
		2'b01: n_bits = 6;
		2'b10: n_bits = 7;
		2'b11: n_bits = 8;
	endcase
	
	
    forever begin
		@(negedge vif.STX_PAD_O);
		item 	     = uart_seq_item::type_id::create("item");
		
		// Wait half a bit period (in WBCLK cycles) to sample at center
		repeat(wb_cycles_per_bit/2) @(posedge vif.WBCLK);

		// Verify start bit
		if (vif.STX_PAD_O != 0) continue;
		
		
		// Collect 8 data bits (assuming LCR[5:3]=3’b011 for 8-bit data)
		item.data = 0;
		for (i = 0; i < n_bits; i++) begin
		repeat(wb_cycles_per_bit) @(posedge vif.WBCLK);
		item.data[i] = vif.STX_PAD_O;
		end

		// Collect parity if enabled (LCR[3]=1)
		if (parity_en) begin
			repeat(wb_cycles_per_bit) @(posedge vif.WBCLK);
			item.parity = vif.STX_PAD_O;

			case ({env_conf.lcr[5], env_conf.lcr[4], env_conf.lcr[3]})
			   3'b0_0_1: begin
				  // PEN=1, SP=0, EPS=0 → Odd parity
				  mask = (1 << n_bits) - 1; // n_bits must be ≤ 8 here since item.data is a byte
				  expected_parity = ~^(item.data & mask);
			   end

			   3'b0_1_1: begin
				  // PEN=1, SP=0, EPS=1 → Even parity
				  mask = (1 << n_bits) - 1; // n_bits must be ≤ 8 here since item.data is a byte
				  expected_parity = ^(item.data & mask);
			   end

			   3'b1_0_1: begin
				  // PEN=1, SP=1, EPS=0 → Stick parity = 1
				  expected_parity = 1'b1;
			   end

			   3'b1_1_1: begin
				  // PEN=1, SP=1, EPS=1 → Stick parity = 0
				  expected_parity = 1'b0;
			   end

			   default: expected_parity = 1'bx;
			endcase

			if (item.parity != expected_parity) item.has_error = 1;
		end

		// Collect stop bits (1 or 2 based on LCR[2])
			// stop bits
			if (env_conf.lcr[2] == 0)
				stop_bits = 1.0;
			else if (n_bits == 5)
				stop_bits = 1.5;
			else
				stop_bits = 2.0;
				
		repeat($rtoi(stop_bits * wb_cycles_per_bit)) @(posedge vif.WBCLK);
		if (vif.STX_PAD_O != 1) item.has_error = 1;  // Framing error

		ap.write(item);
		end
  endtask
endclass
