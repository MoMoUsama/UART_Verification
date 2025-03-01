module UART_TX #(parameter Width=8)(

input CLK_TOP,RST_TOP,
input [Width-1:0] PARALLEL_DATA_TOP,
input PARITY_TYPE_TOP,PARITY_EN_TOP,
input DATA_VALID_TOP,
output SER_OUT_TOP,
output BUSY_TOP

);


/////////////////////////////////////////////////
////////////////////// signals //////////////////
/////////////////////////////////////////////////

wire [1:0] selection_lines;
wire serial_data;
wire parity_bit;
wire ser_en;
wire ser_done;
wire START_BIT = 1'b0;
wire STOP_BIT  =  1'b1;



///////////////////////////////////////////////////
///////////////// instantiation ///////////////////
///////////////////////////////////////////////////

Parity_Calc parity_calc(.PARALLEL_DATA(PARALLEL_DATA_TOP),
                        .Parity_Type(PARITY_TYPE_TOP),
						.Parity_bit(parity_bit),
						.CLK(CLK_TOP),
						.RST(RST_TOP),
						.DATA_VALID(DATA_VALID_TOP),
						.BUSY(BUSY_TOP)
					   );
					   
					   
TX_FSM FSM_TOP ( .MUX_SELECT(selection_lines),
             .SER_DONE(ser_done),
			 .SER_EN(ser_en),
			 .BUSY(BUSY_TOP),
			 .DATA_VALID(DATA_VALID_TOP),
			 .CLK(CLK_TOP),
			 .RST(RST_TOP),
			 .Parity_EN(PARITY_EN_TOP)
			);
			
			
Serializer Serializer_TOP (.PARALLEL_DATA(PARALLEL_DATA_TOP),
                           .SER_EN(ser_en),
						   .SER_DONE(ser_done),
						   .SER_OUT(serial_data),
						   .DATA_VALID(DATA_VALID_TOP),
						   .CLK(CLK_TOP),
						   .RST(RST_TOP),
						   .BUSY(BUSY_TOP)
						  );
						  
MUX MUX_TOP (.IN0(START_BIT),
             .IN1(STOP_BIT),
			 .IN2(serial_data),
			 .IN3(parity_bit),
			 .SELECT(selection_lines),
			 .OUT(SER_OUT_TOP),
			 .CLK(CLK_TOP),
			 .RST(RST_TOP)
			);
			
endmodule
