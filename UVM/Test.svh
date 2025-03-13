class Test extends uvm_test;
    `uvm_component_utils(Test)
	
    Env env;
    VSEQ vseq;
    Config_Obj conf;
	
    function new (string name="Test", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(Config_Obj)::get(this,"","conf",conf))
            `uvm_error("Test","Can't get configuration object from the config db")
			
		if (conf == null)
            `uvm_fatal("Test", "Configuration object is null")
			
        uvm_config_db#(Config_Obj)::set(this,"env","conf",conf);
		
        env=Env::type_id::create("env",this);
        vseq=VSEQ::type_id::create("vseq");
		
    endfunction
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
	
	function void init_vseq();
		vseq.tx_sqr = env.tx_agent.tx_sqr;
		vseq.rx_sqr = env.rx_agent.rx_sqr;
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		init_vseq();
		vseq.start(null);
		phase.drop_objection(this);
	endtask
endclass