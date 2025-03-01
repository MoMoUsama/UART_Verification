module Deserializer #(parameter DW=8)(
    input CLK,RST,
    input Sampled_Bit,
	input Deser_En,
	input BIT_AVAILABLE,
	
	output reg [DW-1:0] P_DATA
);

reg [3:0] i = 'd0;
reg [DW-1:0] P_DATA_REG = 8'd0;

always@(*)
begin

    if(Deser_En)
	begin
	    if(BIT_AVAILABLE)
		begin
	        P_DATA_REG[i] = Sampled_Bit ;
		    i = i + 'd1 ;
		end
	end
	
	else
	    i = 'd0;
	
end

///////// registered output  ///////////////
always@(posedge CLK or negedge RST)
begin
    if(!RST)
        P_DATA <= 'd0;
    else
        P_DATA <= P_DATA_REG;	
end

endmodule