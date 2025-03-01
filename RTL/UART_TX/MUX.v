module MUX (
input  IN0,IN1,IN2,IN3,CLK,RST,
input  [1:0] SELECT,
output reg OUT
);

reg mux_out;

///////////////// seq always //////////////////
always@(posedge CLK or negedge RST)
begin

    if(!RST)
	    OUT<= 'd0;
	else
	    OUT<= mux_out;
end

always@(*)
begin

    case(SELECT)
	    
		2'b00 :
		    mux_out=IN0;
			
		2'b01 :
		    mux_out=IN1;
			
		2'b10 :
		    mux_out=IN2;
			
		2'b11 :
		    mux_out=IN3;
	endcase
end
endmodule
