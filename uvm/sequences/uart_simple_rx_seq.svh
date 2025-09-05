class uart_simple_rx_seq extends uvm_sequence #(uart_seq_item);
  `uvm_object_utils(uart_simple_rx_seq)
   
	Env_Config     env_conf;
	uart_seq_item  item;
	function new(string name = "uart_simple_rx_seq");
		super.new(name);
	endfunction
  
  
    virtual task pre_body();
		`uvm_info("SIMPLE RX SEQUENCE", "IN THE PRE_BODY", UVM_MEDIUM)
		env_conf = Env_Config::type_id::create("env_conf");
		if(!uvm_config_db#(Env_Config)::get(m_sequencer, "" , "env_conf", env_conf)) begin
		  `uvm_fatal("SIMPLE_RX_SEQ No_Config", "env_conf not found in config_db for the SIMPLE_RX_Sequence")
		end
		
    endtask
	
    virtual task body();
		int num_transactions = 5;
		int c = 1;
		repeat(num_transactions) begin
			item = uart_seq_item::type_id::create("item");
			`uvm_info("SIMPLE RX SEQUENCE", "STARTING NEW ITEM", UVM_MEDIUM)
			if(c==num_transactions) item.last_item = 1;
			else 					item.last_item = 0;
			
		    start_item(item);
			if(!item.randomize())
				`uvm_fatal("Randomization Failed", "Failed To Randomize uart_seq_item in Simple RX Sequence")
				
			`uvm_info("SIMPLE RX SEQUENCE", "AFTER RANDOMIZATION", UVM_MEDIUM)
			if(env_conf.lcr[3]) begin //parity enables	
				item.parity = parity_calculation(item);
				if(env_conf.inject_parity_err) item.parity = !item.parity;
			end		  
			
			if(env_conf.inject_stop_err) item.stop = 1'b0;
			else                         item.stop = 1'b1;
	
			`uvm_info("SIMPLE RX SEQUENCE", "STARTING AN ITEM", UVM_MEDIUM)
			finish_item(item);
			c++;
			`uvm_info("SIMPLE RX SEQUENCE", "ITEM FINISHED SUCCESSFULLY" , UVM_MEDIUM)
		end
		`uvm_info("SIMPLE RX SEQUENCE", "SIMPLE RX SEQUENCE SUCCESSFULLY" , UVM_MEDIUM)
    endtask
	
	function bit parity_calculation(input uart_seq_item  item);
		bit parity ;
		int n_bits = this.env_conf.lcr[1:0];
		logic [7:0] mask;
		
		// Collect parity if enabled (LCR[3]=1)
		case ({env_conf.lcr[5], env_conf.lcr[4], env_conf.lcr[3]})
		   3'b0_0_1: begin
			  // PEN=1, SP=0, EPS=0 → Odd parity
			  mask = (1 << n_bits) - 1; // n_bits must be ≤ 8 here since item.data is a byte
			  parity = ~^(item.data & mask);
		   end

		   3'b0_1_1: begin
			  // PEN=1, SP=0, EPS=1 → Even parity
			  mask = (1 << n_bits) - 1; // n_bits must be ≤ 8 here since item.data is a byte
			  parity = ^(item.data & mask);
		   end

		   3'b1_0_1: begin
			  // PEN=1, SP=1, EPS=0 → Stick parity = 1
			  parity = 1'b1;
		   end

		   3'b1_1_1: begin
			  // PEN=1, SP=1, EPS=1 → Stick parity = 0
			  parity = 1'b0;
		   end

		   default: parity = 1'bx;
		endcase
		
		return parity;
	endfunction
	
  
endclass
