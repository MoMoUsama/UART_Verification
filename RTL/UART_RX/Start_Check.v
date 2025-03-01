module Start_Check (
    input CLK,RST,
	input START_EN,
	input SAMPLED_BIT,
    input BIT_AVAILABLE,

    output reg START_ERR	
);

always@(*)
begin

    if(START_EN && BIT_AVAILABLE)
	begin
	    START_ERR = SAMPLED_BIT; 
	end
	
	else
        START_ERR = 1'b0;	
end

endmodule