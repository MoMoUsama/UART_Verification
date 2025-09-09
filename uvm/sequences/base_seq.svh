class base_seq extends uvm_sequence #(wb_seq_item);
  `uvm_object_utils(base_seq)

	uart_reg_block ral_model;
	Env_Config     env_conf;
	function new(string name = "base_seq");
		super.new(name);
	endfunction

    virtual task pre_body();
		`uvm_info("Base Seq", $sformatf("In the Pre-Body"), UVM_LOW)
		if(!uvm_config_db#(uart_reg_block)::get(null, "" , "ral_model", ral_model)) begin
		  `uvm_fatal("NO_RM", "ral_model not found in config_db")
		end
		
		env_conf = Env_Config::type_id::create("env_conf");
		if(!uvm_config_db#(Env_Config)::get(m_sequencer, "" , "env_conf", env_conf)) begin
		  `uvm_fatal("No_Config", "env_conf not found in config_db for the Sequence")
		end
		
		`uvm_info("Base Seq", $sformatf("DONE  the Pre-Body"), UVM_LOW)
    endtask
  
    task program_lcr(bit [7:0] val, bit [15:0] dll);
		uvm_status_e status;
		logic [7:0] data;
		
		this.ral_model.LCR.poke(status,   8'h83, 	.parent(this));
		env_conf.lcr = 8'h83; 
		this.ral_model.LCR.peek(status,   data, 	.parent(this));
		if(data !=8'h83)
			`uvm_error("Back-door ERR", $sformatf("@%0t:  Failed to write 8'h80 in the LCR Through Backdoor",$time/1ns))
			
		this.ral_model.DLL.write(status, dll[7:0],  .parent(this));
		this.ral_model.DLL.read(status,   data, 	.parent(this));
		if(data !=dll[7:0])
			`uvm_error("Front-door ERR", $sformatf("@%0t:  Failed to write %0h in the DLL Through Frontdoor, read value is %0h",$time/1ns, dll[7:0], data))
			
		this.ral_model.DLM.write(status, dll[15:8], .parent(this));
		this.ral_model.DLM.read(status,   data, 	.parent(this));
		if(data !=dll[15:8])
			`uvm_error("Front-door ERR", $sformatf("@%0t:  Failed to write %0h in the DLM Through Frontdoor",$time/1ns, dll[15:8]))
			
		this.ral_model.LCR.poke(status,   val, 	    .parent(this));
		env_conf.lcr = val; 
		this.ral_model.LCR.peek(status,   data, 	.parent(this));
		if(data !=val)
			`uvm_error("Back-door ERR", $sformatf("@%0t:  Failed to write %0h in the LCR Through Backdoor", $time/1ns, val))
			
		
	endtask
  
endclass
