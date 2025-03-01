   class RX_Transaction extends uvm_sequence_item;
    `uvm_object_utils(RX_Transaction)
	
    bit rand [7:0] RX_IN;
	bit rand [5:0] prescale;
	bit rand par_en;
	bit rand par_type;
	
    bit [7:0] RX_OUT;
    bit RX_out_valid;
    bit stp_err;
    bit parity_err;
	bit parity_bit;
	bit stop_bit;
	bit start_bit;
	bit rst;
	int transaction_id;
	static int unsigned transaction_id;	
	
	// Constraint to limit prescale to 4, 8, 16, or 32
	constraint prescale_c {
		prescale inside {4, 8, 16, 32};
	}
	
     task print_tr(input string class_name);
		$display("%0s :%0t RX_Transactio_ID = %0d", class_name, $time,transaction_id);
        $display("inputs: RX_IN = %0d",RX_IN);
        $display("outputs:RX_OUT = %0d RX_out_valid = %0d stp_err = %0d parity_err = %0d",RX_OUT,RX_out_valid, stp_err, parity_err);
    endtask
	
    function new (string name="RX_Transaction");
        super.new(name);
		static_transaction_id++;
		this.transaction_id = static_transaction_id;
    endfunction
	
    function void do_copy(uvm_object rhs);
        RX_Transaction tx;
        if (!$cast(tx, rhs)) begin
            `uvm_error("COPY", "Failed to cast rhs to RX_Transaction")
            return;
        end

        this.RX_IN         = tx.RX_IN;
        this.RX_OUT        = tx.RX_OUT;
        this.prescale      = tx.prescale;
        this.RX_out_valid  = tx.RX_out_valid;
        this.stp_err       = tx.stp_err;
        this.parity_err    = tx.parity_err;
        this.par_type      = tx.par_type;
        this.par_en        = tx.par_en;
        this.parity_bit    = tx.parity_bit;
        this.stop_bit      = tx.stop_bit;
        this.start_bit     = tx.start_bit;
        this.rst           = tx.rst;
        this.transaction_id = tx.transaction_id;
    endfunction

    // Wrapper for do_copy (required by UVM)
    function void copy(uvm_object rhs);
        do_copy(rhs);
    endfunction
	
endclass:RX_Transaction

