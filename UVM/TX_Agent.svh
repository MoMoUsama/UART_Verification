class TX_Agent extends uvm_agent;
    `uvm_component_utils(TX_Agent)
	
    Sequencer #(TX_Transaction) tx_sqr;
    TX_Driver tx_drv;
    TX_Monitor tx_mon;
    uvm_analysis_port#(TX_Transaction) tx_agent_ap;
    virtual TX_IF TXvif;
	
    function new (string name="TX_Agent", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		
        if(!uvm_config_db#(virtual TX_IF)::get(this,"","TXvif",TXvif))
            uvm_report_error("TX_Agent","Can't get TXvif from the config db",UVM_LOW);
			
        uvm_config_db#(virtual TX_IF)::set(this,"tx_drv","TXvif",TXvif);
        uvm_config_db#(virtual TX_IF)::set(this,"tx_mon","TXvif",TXvif);
		
        tx_sqr=Sequencer #(TX_Transaction)::type_id::create("tx_sqr",this);
        tx_drv=TX_Driver::type_id::create("tx_drv",this);
        tx_mon=TX_Monitor::type_id::create("tx_mon",this);
		
        tx_agent_ap=new("tx_agent_ap",this);
    endfunction
	
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        tx_drv.seq_item_port.connect(tx_sqr.seq_item_export); 
        tx_mon.analysis_port.connect(this.tx_agent_ap); 
    endfunction
	
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
	
endclass:TX_Agent