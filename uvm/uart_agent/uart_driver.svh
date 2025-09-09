class uart_driver extends uvm_driver #(uart_seq_item);

  virtual rx_intf vif; // virtual interface to DUT
  Env_Config env_conf;
  uvm_nonblocking_put_port #(uart_seq_item) drv2scb_port;
  
  `uvm_component_utils(uart_driver)

  function new(string name="uart_driver", uvm_component parent=null);
    super.new(name, parent);
	drv2scb_port = new("drv2scb_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    if(!uvm_config_db#(virtual rx_intf)::get(this, "", "RX", vif))
      `uvm_fatal("WB_Driver cannot founf vif", "WB Interface not found in uvm_config_db")
	  
	//env_conf = Env_Config::type_id::create("env_conf");
    if(!uvm_config_db#(Env_Config)::get(this, "", "env_conf", env_conf))
      `uvm_fatal("No env_conf", "No env_conf set in DB for uart_driver");
  endfunction
  
  task run_phase(uvm_phase phase);
	int n_bits, i;
	real stop_bits; 
	bit parity_en         = this.env_conf.lcr[3]; 
	int wb_cycles_per_bit = this.env_conf.wb_cycles_per_bit;
	uart_seq_item tr;
	
	super.run_phase(phase);
	
	case(this.env_conf.lcr[1:0])
		2'b00: n_bits = 5;
		2'b01: n_bits = 6;
		2'b10: n_bits = 7;
		2'b11: n_bits = 8;
	endcase
	
	vif.SRX_PAD_I<=1'b1;
	repeat(3) @(posedge vif.WBCLK);
	
    forever begin
			`uvm_info("UART_DRIVER", "Waiting for get_next_item", UVM_HIGH)
			seq_item_port.get_next_item(tr);
			`uvm_info("UART Driver", $sformatf("after get_next_item()"), UVM_MEDIUM)
			void'(drv2scb_port.try_put(tr));
			
			`uvm_info("UART Driver", $sformatf("Received Item:\n%s", tr.sprint()), UVM_MEDIUM)
		
			vif.SRX_PAD_I<= 'b0; //start
			repeat(wb_cycles_per_bit) @(posedge vif.WBCLK);
			

			// data
			for (i = 0; i < n_bits; i++) begin
				vif.SRX_PAD_I<= tr.data[i];
				repeat(wb_cycles_per_bit) @(posedge vif.WBCLK);
			end
			
			if(parity_en) begin
				vif.SRX_PAD_I<=tr.parity;
				repeat(wb_cycles_per_bit) @(posedge vif.WBCLK);
			end
			
			// stop bits
			if (env_conf.lcr[2] == 0)
				stop_bits = 1.0;
			else if (n_bits == 5)
				stop_bits = 1.5;
			else
				stop_bits = 2.0;

			vif.SRX_PAD_I <= tr.stop;
			repeat($rtoi(stop_bits * wb_cycles_per_bit)) @(posedge vif.WBCLK)
			
			@(posedge vif.WBCLK); 
			seq_item_port.item_done();
			`uvm_info("UART Driver", $sformatf("@%0t:  Item drived SUCCESFULLY", $time/1ns), UVM_MEDIUM)
    end
	`uvm_info("UART Driver", $sformatf("@%0t:  Driver Completed Successfully", $time/1ns), UVM_MEDIUM)
  endtask
endclass
