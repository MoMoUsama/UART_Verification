class TX_Monitor extends uvm_monitor;
    `uvm_component_utils(TX_Monitor)
    
    virtual TX_IF TXvif;
    TX_Transaction tx_item;
    uvm_analysis_port #(TX_Transaction) analysis_port;
    
    function new(string name="TX_Monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual TX_IF)::get(this,"","TXvif",TXvif))
            uvm_report_error("Monitor","Can't get TX_IF from the config db",UVM_LOW);
            
        analysis_port = new("analysis_port", this);
        tx_item = TX_Transaction::type_id::create("tx_item");
    endfunction
    
    task run_phase(uvm_phase phase);
		super.run_phase(phase);
        forever begin
            collect_transaction();
            analysis_port.write(tx_item);
			$display("Transaction Written Successfully to Scoreboard and Subscriber");
			tx_item.print_tr("TX_Monitor");
        end
    endtask
    
    task collect_transaction();
    
        @(posedge TXvif.data_valid);
        
        // Copy input control signals that were sampled by the TX module
        tx_item.P_DATA   = TXvif.P_DATA;
        tx_item.par_en   = TXvif.par_en;
        tx_item.par_type = TXvif.par_type;
        
        // Sample start bit
        @(negedge TXvif.TX_OUT);
		@(negedge TXvif.clk);
        for(int i=0; i<8; i++) begin
            @(negedge TXvif.clk);
            tx_item.TX_OUT[i] = TXvif.TX_OUT;
        end
         
		 //parity
        if(tx_item.par_en) begin
            @(negedge TXvif.clk);
            tx_item.parity_bit = TXvif.TX_OUT;
        end
        
		//stop
        @(negedge TXvif.clk);
        tx_item.stop_bit = TXvif.TX_OUT;
		
    endtask
    
endclass: TX_Monitor