module TX_FSM (

input  CLK,RST,
input  SER_DONE,
input  Parity_EN,
input  DATA_VALID,
output reg SER_EN,
output reg BUSY,
output reg [1:0] MUX_SELECT
);

/////////////////////// signals /////////////////////////
reg [2:0] cur_state , nxt_state ;

localparam
            IDLE=3'b000,
		    S1=3'b001,
		    S2=3'b011,
		    S3=3'b010,
			S4=3'b110;

			
/////////////////////  nxt state calculator  ////////////////////
always@(posedge CLK or negedge RST)
begin
    
	if(!RST)
	begin
	    cur_state<=IDLE;
	end
	
	else
	begin
	    cur_state<=nxt_state;
	end
end


//////////////////// combinational always for output & nxt_state  //////////////////////
always@(*)
begin

    case(cur_state)
	
	    IDLE : 
		begin
		    MUX_SELECT=2'b01; //out 1 
			BUSY=1'b0;
			SER_EN=1'b0;
			
            if(DATA_VALID)
                nxt_state=S1;  //should I assert the BUSY here or at the S1?????
            else
                nxt_state=IDLE;			
		end


	    S1  : //start bit state 
		begin
		
		    MUX_SELECT=2'b00; //out start bit
			BUSY=1'b1;
			SER_EN=1'b0;
			nxt_state=S2;
		end

		
	    S2  :  // Data transmission state
		begin
		    MUX_SELECT=2'b10; //out data bits
			BUSY=1'b1;
			SER_EN=1'b1;
			
			if(SER_DONE)
			begin
			SER_EN=1'b0;
			    if(Parity_EN)
				    nxt_state=S3;  //out a parity bit then the stop bit
				else
				    nxt_state=S4; //out a stop bit only
			end
			
			else
			    nxt_state=S2;
		end
		
	    S3  :  //parity transmission state
		begin
		
		    MUX_SELECT=2'b11;   //out the parity bit
			BUSY=1'b1;
			SER_EN=1'b0;
			nxt_state=S4;
		end

	    S4  :  //stop bit transmission state 
		begin
		
		    MUX_SELECT=2'b01;   //out the stop bit
			BUSY=1'b1;
			SER_EN=1'b0;
			nxt_state=IDLE;
		end
		
		default :
		begin
		    MUX_SELECT=2'b01;   //out 1 (IDLE)
			BUSY=1'b0;
			SER_EN=1'b0;
			nxt_state=IDLE;
		end
	
	endcase

end

endmodule
