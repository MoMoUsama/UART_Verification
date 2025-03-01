interface TX_IF(input logic clk, input logic rst);
    logic [7:0] P_DATA;               
    logic par_en;            
    logic par_type; 
	logic data_valid;	   
    logic TX_OUT;            
    logic BUSY;           

    modport DUT (
        input clk, rst, P_DATA, empty_flag, par_en, par_type, prescale,
        output TX_OUT, BUSY
    );

    modport TB (
        output P_DATA, empty_flag, par_en, par_type, prescale,
        input TX_OUT, BUSY
    );
endinterface