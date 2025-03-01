interface RX_IF(input logic clk, input logic rst);
    logic RX_IN;  
	logic [5:0] prescale; 
	logic par_type;
	logic par_en;

//////// outputs //////////	
    logic [7:0] RX_OUT;         
    logic RX_out_valid;     
    logic stp_err;               
    logic parity_err;           

    modport DUT (
        input clk, rst, RX_IN, prescale,par_type,par_en
        output RX_OUT, RX_out_valid, stp_err, parity_err
    );

    modport TB (
        output RX_IN, prescale,
        input RX_OUT, RX_out_valid, stp_err, parity_err
    );
endinterface
