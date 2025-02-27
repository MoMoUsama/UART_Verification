module UART_RX #(parameter DW=8)(
    input CLK_TOP,RST_TOP,
	input S_DATA_TOP,
	input PARITY_EN_TOP , PARITY_TYPE_TOP,
	input [5:0] PRESCALE_TOP,
	
	output [DW-1:0] P_DATA,
	output VALID, STOP_ERR,PARITY_ERR
);

//////////////   SIGNALS   //////////////

wire START_GLSH_TOP;
wire [3:0] BIT_CNT_TOP;
wire BIT_AVAILABLE_TOP;
wire PAR_EN_TOP;
wire STR_CHK_EN_TOP;
wire STP_CHK_EN_TOP;
wire Parity_Chk_En_TOP;
wire DSER_EN_TOP;
wire DAT_SAMPL_EN_TOP;
wire COUNTER_EN_TOP;
wire [5:0] EDG_CNT_TOP;
wire Sampled_bit_TOP;

///////////////////// INSTANTIATION  ///////////////////

RX_FSM FSM_TOP(
     
	.S_DATA(S_DATA_TOP),
    .CLK(CLK_TOP),
	.RST(RST_TOP),
	.START_GLSH(START_GLSH_TOP),
	.PAR_ERR(PARITY_ERR),
	.STP_ERR(STOP_ERR),
	.BIT_CNT(BIT_CNT_TOP), // MAX 11 BITS (start parity 8bits stop)
	.BIT_AVAILABLE(BIT_AVAILABLE_TOP),
	.PAR_EN(PARITY_EN_TOP),
	
	.DATA_VALID(VALID),
	.STR_CHK_EN(STR_CHK_EN_TOP),
	.STP_CHK_EN(STP_CHK_EN_TOP),
	.PRT_CHK_EN(PRT_CHK_EN_TOP),
	.DSER_EN(DSER_EN_TOP),
	.DAT_SAMPL_EN(DAT_SAMPL_EN_TOP),
	.COUNTER_EN(COUNTER_EN_TOP)
);




Parity_Check #(.DW(DW)) Parity_Check_TOP(

    .Parity_Type(PARITY_TYPE_TOP),
	.Parity_Chk_En(Parity_Chk_En_TOP),
	.Sampled_bit(Sampled_bit_TOP),
	.P_Data(P_DATA),
	.Bit_Available(BIT_AVAILABLE_TOP),
	.Bit_Cnt(BIT_CNT_TOP),
	.CLK(CLK_TOP),
	.RST(RST_TOP),
	
	.Parity_Err(PARITY_ERR)
);


 STOP_CHECK STOP_CHECK_TOP(
    .SAMPLED_BIT(Sampled_bit_TOP),
	.BIT_AVAILABLE(BIT_AVAILABLE_TOP),
	.RST(RST_TOP),
	.STOP_CHK_EN(STP_CHK_EN_TOP),
	.CLK(CLK_TOP),
	
	.STOP_ERR(STOP_ERR)
);


Start_Check Start_Check_TOP(
    .CLK(CLK_TOP),
	.RST(RST_TOP),
	.START_EN(STR_CHK_EN_TOP),
	.SAMPLED_BIT(Sampled_bit_TOP),
    .BIT_AVAILABLE(BIT_AVAILABLE_TOP),

    .START_ERR(START_GLSH_TOP)	
);


Deserializer #(.DW(DW)) Deserializer_TOP(

    .Sampled_Bit(Sampled_bit_TOP),
	.Deser_En(DSER_EN_TOP),
	.BIT_AVAILABLE(BIT_AVAILABLE_TOP),
	.CLK(CLK_TOP),
	.RST(RST_TOP),
	
	.P_DATA(P_DATA)
);


Edge_Bit_Counter Edge_Bit_Counter_TOP(
    .CLK(CLK_TOP),
	.RST(RST_TOP),
	.EN(COUNTER_EN_TOP),
	.PRESCALE(PRESCALE_TOP),
	
	.Edge_Cnt(EDG_CNT_TOP), // 4 8 16 32  
	.Bit_Cnt(BIT_CNT_TOP)   // MAX 11 BITS (start parity 8bits stop)
);



Data_Sampling Data_Sampling_TOP(

    .CLK(CLK_TOP),
	.RST(RST_TOP),
	.EDG_CNT(EDG_CNT_TOP),
	.DAT_SAMPL_EN(DAT_SAMPL_EN_TOP),
	.PRESCALE(PRESCALE_TOP),
	.S_DATA(S_DATA_TOP),
	
	.SAMPLED_BIT (Sampled_bit_TOP),
	.BIT_AVAILABLE(BIT_AVAILABLE_TOP)
);

endmodule