class RX_Driver extends uvm_driver#(RX_Transaction);
    `uvm_component_utils(RX_Driver)
	
    RX_Transaction rx_item;
    virtual RX_IF RXvif;                         //virtual interface handle
	//uvm_seq_item_pull_port#(RX_Transaction) seq_item_port; inherited from uvm_driver

    function new (string name="RX_Driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		
        if(!uvm_config_db#(virtual RX_IF)::get(this,"","RXvif",RXvif))
            `uvm_error("Driver","Can't get RX_IF from the config db")
	
        rx_item=RX_Transaction::type_id::create("rx_item");
		//seq_item_port = new("seq_item_port",this);

    endfunction
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
	
	
	task drive_item(input RX_Transaction rx_item);
	
		//set configuration signals
		@(posedge RXvif.clk);
		RXvif.prescale  <= rx_item.prescale;
		RXvif.par_type  <= rx_item.par_type;
		RXvif.par_en    <= rx_item.par_en;
		RXvif.rst       <= rx_item.rst;
		
		// Start bit
		RXvif.RX_IN <= rx_item.start_bit;
		repeat(rx_item.prescale) @(posedge RXvif.clk);
		
		// Data bits
		for(int i=0; i<8; i++) begin
			RXvif.RX_IN <= rx_item.RX_IN[i]; 
			repeat(rx_item.prescale) @(posedge RXvif.clk);
		end
		
		// Parity bit 
		if(rx_item.par_en) begin
			bit parity;
			parity = ^rx_item.RX_IN;
			if(rx_item.valid_parity) begin //valid parity
				if(rx_item.par_type) begin //even
					RXvif.RX_IN <= parity;
				end
				
				else begin 
					RXvif.RX_IN <= ~(parity);
				end
			end
			else begin //wrong parity
				if(rx_item.par_type) begin //even
					RXvif.RX_IN <= ~(parity);
				end
				
				else begin 
					RXvif.RX_IN <= (parity);
				end
			end

			repeat(rx_item.prescale) @(posedge RXvif.clk);
		end
		
		// Stop bit
		RXvif.RX_IN <= rx_item.stop_bit;
		repeat(rx_item.prescale) @(posedge RXvif.clk);  
		
		// Return to idle
		RXvif.RX_IN <= 1'b1;
	endtask
	
	
    task run_phase(uvm_phase phase);
		super.run_phase(phase);
        forever begin
        seq_item_port.get_next_item(rx_item);
		
		$display("Transaction Recieved Successfully");
		rx_item.print_tr("RX_Driver");
		
        drive_item(rx_item);
        seq_item_port.item_done();
		
		$display("Transaction_ID=%0d Sent Successfully to the DUT",rx_item.transaction_id);
        end
    endtask
	
endclass:RX_Driver
    