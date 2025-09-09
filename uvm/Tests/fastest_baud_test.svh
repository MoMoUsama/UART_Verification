class  fastest_baud_test extends base_test;
    `uvm_component_utils(fastest_baud_test)
	
    function new (string name="fastest_baud_test", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
		bit [7:0] lcr, fcr;
		bit [15:0] dl;
        super.build_phase(phase);
		lcr = 8'h03;
		fcr = 8'hc0;
		dl = 16'h0001;
		super.configure_test(lcr, dl, 25, 25);
	
		if(super.env_conf==null) `uvm_fatal("CFG ERR", "env_conf not created")
		uvm_config_db#(Env_Config)::set(this,"env*","env_conf", super.env_conf);
		`uvm_info("Test Build", "Done Building the Test", UVM_MEDIUM)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
	
	function void init_vseq();
		vseq.wb_sqr = env.wb_agent.seqr;
		vseq.uart_sqr = env.u_agent.seqr;
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		init_vseq();
		`uvm_info("TEST", "DONE VSEG INIT", UVM_MEDIUM)
		vseq.start(null);
		phase.phase_done.set_drain_time(this, 2ms);
		phase.drop_objection(this);
	endtask

endclass: fastest_baud_test