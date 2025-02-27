module UART #(parameter DW=8)(

	input TX_clk,RX_clk,
	input rst,
	input RX_IN, 
	input [DW-1:0] P_DATA, //fifo
	input empty_flag, //fifo
	input par_en,par_type, //reg file
	input [5:0] prescale, //reg file
	
	output TX_OUT,BUSY,
	output [DW-1:0] RX_OUT, //to DATA_SYNC
	output RX_out_valid,  //to DATA_SYNC
	output stp_err,parity_err
);

////////////////////////////////////////
////////// 	Instantiation 	////////////
////////////////////////////////////////

UART_TX uart_tx(

		.CLK_TOP(TX_clk),
		.RST_TOP(rst),
		.PARALLEL_DATA_TOP(P_DATA),
		.PARITY_TYPE_TOP(par_type),
		.PARITY_EN_TOP(par_en),
		.DATA_VALID_TOP(!empty_flag),
		
		.SER_OUT_TOP(TX_OUT),
		.BUSY_TOP(BUSY)

);

UART_RX #(.DW(DW)) uart_rx(
		.CLK_TOP(RX_clk),
		.RST_TOP(rst),
		.S_DATA_TOP(RX_IN),
		.PARITY_EN_TOP(par_en),
		.PARITY_TYPE_TOP(par_type),
		.PRESCALE_TOP(prescale),
		
		.P_DATA(RX_OUT),
		.VALID(RX_out_valid),
		.STOP_ERR(stp_err),
		.PARITY_ERR(parity_err)
);


endmodule