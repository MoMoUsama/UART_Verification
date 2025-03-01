class TX_Driver extends uvm_driver#(TX_Transaction);
    `uvm_component_utils(TX_Driver)
	
    TX_Transaction tx_item;
    virtual TX_IF TXvif;                         //virtual interface handle
	uvm_seq_item_pull_port#(TX_Transaction) seq_item_port;

    function new (string name="TX_Driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		
        if(!uvm_config_db#(virtual TX_IF)::get(this,"","TXvif",TXvif))
            `uvm_error("Driver","Can't get TX_IF from the config db")
	
        tx_item=TX_Transaction::type_id::create("tx_item");
		seq_item_port = new uvm_seq_item_pull_port("seq_item_port",this);

    endfunction
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
	
	task drive_item(input TX_Transaction tx_item); 
		@(negedge TXvif.clk);
		while(TXvif.BUSY) @(negedge TXvif.clk); 
		
		TXvif.P_DATA     <= tx_item.P_DATA;
		TXvif.par_en     <= tx_item.par_en;
		TXvif.par_type   <= tx_item.par_type;
		TXvif.rst        <= tx_item.rst;
		TXvif.data_valid <= 1'b1; 
		
		@(negedge TXvif.clk); //data valid is high for only one clock cycle
		TXvif.data_valid <= 1'b0;  
	endtask
	
    task run_phase(uvm_phase phase);
        forever begin
        seq_item_port.get_next_item(tx_item);
		
		$display("Transaction Recieved Successfully");
		tx_item.print_tr("TX_Driver");
		
        drive_item(tx_item);
        seq_item_port.item_done();
		
		$display("Transaction_ID=%0d Sent Successfully to the DUT",tx_item.transaction_id);
        end
    endtask
	
endclass:TX_Driver
