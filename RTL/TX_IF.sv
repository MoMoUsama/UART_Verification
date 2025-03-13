interface TX_IF(input logic clk);
    logic [7:0] P_DATA;               
    logic par_en;            
    logic par_type; 
	logic data_valid;	   
    logic TX_OUT;            
    logic BUSY;
	logic rst;

    modport DUT (
        input clk, rst, P_DATA, par_en, par_type,
        output TX_OUT, BUSY
    );

    modport TB (
        output P_DATA, par_en, par_type,
        input TX_OUT, BUSY
    );
endinterface