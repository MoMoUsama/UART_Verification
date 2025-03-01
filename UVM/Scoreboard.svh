class Scoreboard extends uvm_scoreboard;
    `uvm_component_utils(Scoreboard)
	
    uvm_analysis_imp#(TX_Transaction,Scoreboard) tx_scb_imp;
	uvm_analysis_imp#(RX_Transaction,Scoreboard) rx_scb_imp;
	
    function new (string name="Scoreboard", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tx_scb_imp=new("tx_scb_imp",this);
		rx_scb_imp=new("rx_scb_imp",this);
    endfunction
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
	
    function void write_tx(input TX_Transaction item);
        TX_Transaction tx_item = TX_Transaction::type_id::create("tx_item");
        tx_item.copy(item);

		$display("Transaction_ID %0d Recieved Successfully in the Scoreboard", tx_item.transaction_id);
		tx_item.print_tr("Scoreboard");
		
        // Example: Check reset signal
        if (tx_item.rst) begin
            `uvm_info("SCOREBOARD", "Reset signal is active", UVM_MEDIUM)
        end
		
		else begin 
			if (tx_item.data_valid) begin
				`uvm_info("SCOREBOARD", "Transaction is valid", UVM_MEDIUM)
			end else begin
				`uvm_warning("SCOREBOARD", "Transaction is invalid")
			end

			if (tx_item.par_en) begin
				bit expected_parity = ^tx_item.P_DATA;
				if (tx_item.par_type) begin
					expected_parity = ~expected_parity; // Invert for odd parity
				end
				if (tx_item.parity_bit != expected_parity) begin
					`uvm_error("SCOREBOARD", $sformatf("Parity error: Expected=%0b, Received=%0b", expected_parity, tx_item.parity_bit))
				end else begin
					`uvm_info("SCOREBOARD", "Parity check passed", UVM_MEDIUM)
				end
			end

			if (tx_item.stop_bit != 1'b1) begin
				`uvm_error("SCOREBOARD", "Stop bit error: Expected=1, Received=0")
			end else begin
				`uvm_info("SCOREBOARD", "Stop bit check passed", UVM_MEDIUM)
			end
		end
    endfunction
	
    function void write_rx(input RX_Transaction item);

        RX_Transaction rx_item = RX_Transaction::type_id::create("rx_item");
        rx_item.copy(item);

		$display("Transaction_ID %0d Recieved Successfully in the Scoreboard", rx_item.transaction_id);
		rx_item.print_tr("Scoreboard");

        // Example: Check reset signal
        if (rx_item.rst) begin
            `uvm_info("SCOREBOARD", "Reset signal is active", UVM_MEDIUM)
        end
		
		else begin 

			if (rx_item.RX_out_valid) begin
				`uvm_info("SCOREBOARD", "RX Transaction is valid", UVM_MEDIUM)
			end else begin
				`uvm_warning("SCOREBOARD", "RX Transaction is invalid")
			end

			if (rx_item.stp_err) begin
				`uvm_error("SCOREBOARD", "Stop bit error detected")
			end else begin
				`uvm_info("SCOREBOARD", "Stop bit check passed", UVM_MEDIUM)
			end

			if (rx_item.par_en) begin
				bit expected_parity = ^rx_item.RX_IN;
				if (rx_item.par_type) begin
					expected_parity = ~expected_parity; // Invert for odd parity
				end
				if (rx_item.parity_bit != expected_parity) begin
					`uvm_error("SCOREBOARD", $sformatf("Parity error: Expected=%0b, Received=%0b", expected_parity, rx_item.parity_bit))
				end else begin
					`uvm_info("SCOREBOARD", "Parity check passed", UVM_MEDIUM)
				end
			end
		end
    endfunction
	
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
	
endclass: Scoreboard
