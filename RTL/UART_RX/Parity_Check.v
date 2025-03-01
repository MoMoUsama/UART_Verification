module Parity_Check #(parameter DW=8)(

    input CLK,RST,
    input Parity_Type,
	input Parity_Chk_En,
	input Sampled_bit,
	input [DW-1:0] P_Data,
	input Bit_Available,
	input [3:0] Bit_Cnt,
	
	output reg Parity_Err
);

reg parity_bit , check , Parity_out_reg = 1'b0;

always@(*)
begin

    if(Parity_Chk_En && Bit_Available)
	    parity_bit = Sampled_bit;
	
	if( Bit_Available && Bit_Cnt == 'd9) // 10 bits recieved (start  8bits parity)
	begin
	    check = ^P_Data ;
		
		if( parity_bit != check )
		    Parity_out_reg = 'd1;
        else
            Parity_out_reg = 'd0;		
	end
	    
end


///////// registered output  ///////////////
always@(posedge CLK or negedge RST)
begin

    if(!RST)
	    Parity_Err<= 1'b0;
	else
	    Parity_Err <= Parity_out_reg;
end
endmodule 


