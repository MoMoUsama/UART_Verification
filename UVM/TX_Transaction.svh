class TX_Transaction extends uvm_sequence_item;
    `uvm_object_utils(TX_Transaction) 
	
	
    rand bit [7:0] P_DATA;                 
    rand bit par_en;               
    rand bit par_type;
	
    bit data_valid;  
    bit [7:0] TX_OUT;                   
    bit BUSY; 
	bit parity_bit;
	bit stop_bit;
	bit rst;

    // Added field to help matching in scoreboard
    static int unsigned transaction_id;	

    function new (string name = "TX_Transaction");
        super.new(name);
    endfunction

    task print_tr(input string class_name);
        $display("%0s :%0t TX_Transaction_ID = %0d", class_name, $time,transaction_id);
        $display("Inputs : P_DATA = %0d empty_flag = %0d par_en = %0d par_type = %0d prescale = %0d",
                 P_DATA, empty_flag, par_en, par_type, prescale);
        $display("Outputs: TX_OUT = %0d BUSY = %0d", TX_OUT, BUSY);
    endtask
	
    function void do_copy(uvm_object rhs);
        TX_Transaction tx;
        if (!$cast(tx, rhs)) begin
            `uvm_error("COPY", "Failed to cast rhs to TX_Transaction")
            return;
        end

        this.P_DATA         = tx.P_DATA;
        this.par_en         = tx.par_en;
        this.par_type       = tx.par_type;
        this.data_valid     = tx.data_valid;
        this.TX_OUT         = tx.TX_OUT;
        this.BUSY            = tx.BUSY;
        this.parity_bit      = tx.parity_bit;
        this.stop_bit        = tx.stop_bit;
        this.rst             = tx.rst;
        this.transaction_id  = tx.transaction_id;
    endfunction

    // Wrapper for do_copy (required by UVM)
    function void copy(uvm_object rhs);
        do_copy(rhs);
    endfunction

endclass: TX_Transaction
