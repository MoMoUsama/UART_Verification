interface RX_IF(input logic clk);
    logic RX_IN;  
	logic [5:0] prescale; 
	logic par_type;
	logic par_en;
	logic rst;

//////// outputs //////////	
    logic [7:0] RX_OUT;         
    logic RX_out_valid;     
    logic stop_err;               
    logic parity_err;           

    modport DUT (
        input clk, rst, RX_IN, prescale,par_type,par_en,
        output RX_OUT, RX_out_valid, stop_err, parity_err
    );

    modport TB (
        output RX_IN, prescale,
        input RX_OUT, RX_out_valid, stop_err, parity_err
    );
endinterface
