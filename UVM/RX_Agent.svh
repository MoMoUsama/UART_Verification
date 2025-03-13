class RX_Agent extends uvm_agent;
    `uvm_component_utils(RX_Agent)
	
    Sequencer #(RX_Transaction) rx_sqr;
    RX_Driver rx_drv;
    RX_Monitor rx_mon;
    uvm_analysis_port#(RX_Transaction) rx_agent_ap;
    virtual RX_IF RXvif;
	
    function new (string name="RX_Agent", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		
        if(!uvm_config_db#(virtual RX_IF)::get(this,"","RXvif",RXvif))
            uvm_report_error("RX_Agent","Can't get RXvif from the config db",UVM_LOW);
			
        uvm_config_db#(virtual RX_IF)::set(this,"rx_drv","RXvif",RXvif);
        uvm_config_db#(virtual RX_IF)::set(this,"rx_mon","RXvif",RXvif);
		
        rx_sqr=Sequencer #(RX_Transaction)::type_id::create("rx_sqr",this);
        rx_drv=RX_Driver::type_id::create("rx_drv",this);
        rx_mon=RX_Monitor::type_id::create("rx_mon",this);
		
        rx_agent_ap=new("rx_agent_ap",this);
    endfunction
	
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        rx_drv.seq_item_port.connect(rx_sqr.seq_item_export); 
        rx_mon.analysis_port.connect(this.rx_agent_ap); 
    endfunction
	
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
	
endclass:RX_Agent