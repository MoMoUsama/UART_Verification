class base_test extends uvm_test;
    `uvm_component_utils(base_test)
	
    uart_env env;
    uart_virtual_sequence vseq;
    Env_Config env_conf;
	
    function new (string name="base_test", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
	task configure_test(bit [7:0] lcr, bit [15:0] dll);
		this.env_conf.lcr = lcr;
		this.env_conf.dll = dll;
		this.env_conf.wb_cycles_per_bit = dll*16;
	endtask
	
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		env_conf = Env_Config::type_id::create("env_conf");
		
        if(!uvm_config_db#(virtual wb_intf)::get(this,"","WB", env_conf.WB))
            `uvm_error("base_test","Can't get the WB Interface from the COnfig DB")
			
		if(!uvm_config_db#(virtual tx_intf)::get(this,"","TX", env_conf.TX))
            `uvm_error("base_test","Can't get the TX Interface from the COnfig DB")	
			
		if(!uvm_config_db#(virtual rx_intf)::get(this,"","RX", env_conf.RX))
            `uvm_error("base_test","Can't get the RX Interface from the COnfig DB")	
			
		if(!uvm_config_db#(virtual irq_intf)::get(this,"","IRQ", env_conf.IRQ))
            `uvm_error("base_test","Can't get the IRQ Interface from the COnfig DB")

		if(!uvm_config_db#(virtual modem_intf)::get(this,"","MODEM", env_conf.MODEM))
            `uvm_error("base_test","Can't get the MODEM Interface from the COnfig DB")						
		
        env=uart_env::type_id::create("env",this);
        vseq=uart_virtual_sequence::type_id::create("vseq");
	
    endfunction
	
endclass: base_test