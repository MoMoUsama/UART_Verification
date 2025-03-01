class Env extends uvm_env;
    `uvm_component_utils(Env)
    TX_Agent tx_agent;
	RX_Agent rx_agent;
    Subscriber cov;
    Scoreboard scb;
	Config_Obj conf;
    virtual TX_IF TXvif;
	virtual RX_IF RXvif;
	
   function new (string name="Env", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		
        tx_agent=TX_Agent::type_id::create("tx_agent",this);
		rx_agent=RX_Agent::type_id::create("rx_agent",this);
        scb=Scoreboard::type_id::create("scb",this);
        cov=Subscriber::type_id::create("cov",this);
		//conf=Config_Obj::type_id::create("conf",this);
		
        if(!uvm_config_db#(Config_Obj)::get(this,"","conf",conf))
            `uvm_error("Env","Can't get configuration object from the config db")
			
		TXvif = conf.TXvif;
		RXvif = conf.RXvif;
		
        uvm_config_db#(virtual TX_IF)::set(this,"tx_agent","TXvif",TXvif);
		uvm_config_db#(virtual RX_IF)::set(this,"rx_agent","RXvif",RXvif);
		
    endfunction
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        tx_agent.tx_agent_ap.connect(scb.tx_scb_imp);
        tx_agent.tx_agent_ap.connect(cov.tx_sub_imp);
		
        rx_agent.rx_agent_ap.connect(scb.rx_scb_imp);
        rx_agent.rx_agent_ap.connect(cov.rx_sub_imp);
		`uvm_info("Env","connect phase done in the Env")
		
    endfunction
	
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
	
endclass:Env