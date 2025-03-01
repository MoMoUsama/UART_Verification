module STOP_CHECK (
    input SAMPLED_BIT,BIT_AVAILABLE,
	input RST,CLK,
	input STOP_CHK_EN,
	
	output reg STOP_ERR
);

reg STOP_ERR_REG = 1'b0;

always@(*)
begin
    if(STOP_CHK_EN && BIT_AVAILABLE)
	begin
	
	    if(!SAMPLED_BIT)
		    STOP_ERR_REG = 'd1;
	end
	
end


///////// registered output  ///////////////
always@(posedge CLK or negedge RST)
begin
    if(!RST)
        STOP_ERR <= 1'b0;
    else
        STOP_ERR <= STOP_ERR_REG;	
end

endmodule