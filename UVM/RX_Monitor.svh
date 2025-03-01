  class RX_Monitor extends uvm_monitor;
    `uvm_component_utils(RX_Monitor)
    
    virtual RX_IF RXvif;
    uvm_analysis_port #(RX_Transaction) analysis_port;
    
    function new(string name="RX_Monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual RX_IF)::get(this,"","RXvif",RXvif))
            `uvm_error("Monitor","Can't get RX_IF from the config db")
            
        analysis_port = new("analysis_port", this);

    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
			RX_Transaction rx_item = RX_Transaction::type_id::create("rx_item");
            collect_transaction();
            analysis_port.write_rx(rx_item);
			$display("Transaction Written Successfully to Scoreboard and Subscriber");
			rx_item.print_tr("RX_Monitor");
        end
    endtask
    
    task collect_transaction();
	
		if(! RXvif.rst) begin
			rx_item.rst = 1'b0;
			@(posedge RXvif.rst_n);
			return;
		end
		
		//Sample start bit
        @(negedge RXvif.RX_IN);
		rx_item.start_bit = 1'b0;
		repeat(RXvif.prescale) @(posedge RXvif.clk);
		
		
        for(int i=0; i<8; i++) begin
            repeat(RXvif.prescale/2) @(posedge RXvif.clk);
            rx_item.RX_IN[i] = RXvif.RX_IN;
			repeat(RXvif.prescale/2) @(posedge RXvif.clk);
        end
         
		//parity
        if(rx_item.par_en) begin
            repeat(RXvif.prescale/2) @(posedge RXvif.clk);
            rx_item.parity_bit = RXvif.RX_IN;
			repeat(RXvif.prescale/2) @(posedge RXvif.clk);
        end
        
		//stop
        @(negedge RXvif.clk);
		repeat(RXvif.prescale/2) @(posedge RXvif.clk);
        rx_item.stop_bit = RXvif.RX_IN;
		
		fork
			begin
				@(posedge RXvif.RX_out_valid);
			end
			begin
				repeat(RXvif.prescale) @(posedge RXvif.clk);
			end
		join_any
		disable fork;
        
        //Copy input control signals that were sampled by the TX module
        rx_item.RX_OUT       = RXvif.RX_OUT;
        rx_item.parity_err   = RXvif.parity_err;
        rx_item.stop_err     = RXvif.stop_err;
		rx_item.rst          = 1'b1;
         
		
    endtask
    
endclass: RX_Monitor