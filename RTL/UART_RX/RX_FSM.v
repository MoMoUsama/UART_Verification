module RX_FSM (
     
	input S_DATA,
    input CLK,RST,
	input START_GLSH,
	input PAR_ERR,
	input STP_ERR,
	input [3:0] BIT_CNT, // MAX 11 BITS (start parity 8bits stop)
	input BIT_AVAILABLE,
	input PAR_EN,
	
	output reg DATA_VALID,
	output reg STR_CHK_EN,
	output reg STP_CHK_EN,
	output reg PRT_CHK_EN,
	output reg DSER_EN,
	output reg DAT_SAMPL_EN,
	output reg COUNTER_EN
);

reg [2:0] nxt_state , curr_state ;
reg Data_VALID_REGISTER ; 

//////////// states in GRAY ENCODING /////////////////
localparam IDLE     = 3'b000,
           START    = 3'b001,
		   DATA     = 3'b011,
		   PARITY   = 3'b010,
		   STOP     = 3'b110,
		   VALIDATE = 3'b100;
		   
           
///////////////// SEQ //////////
always@(posedge CLK or negedge RST)
begin
    if(!RST)
	    curr_state<= IDLE;
	else
	    curr_state<= nxt_state;
end


///////////////////  OUTPUT Logic /////////////////
always@(*)
begin
    case(curr_state)
	    
		IDLE:
		begin
		    Data_VALID_REGISTER = 'd0;
			STP_CHK_EN = 'd0;
			PRT_CHK_EN = 'd0;
			DSER_EN    = 'd0;
			STR_CHK_EN = 'd0;
			DAT_SAMPL_EN = 'd0;
			COUNTER_EN = 'd0;
			
			if(S_DATA == 'd0)
			begin
			    STR_CHK_EN = 'd1;
			    DAT_SAMPL_EN = 'd1;
				COUNTER_EN = 'd1;
			end
		end
		
		START:
		begin
		    Data_VALID_REGISTER = 'd0;
			STP_CHK_EN = 'd0;
			PRT_CHK_EN = 'd0;
			DSER_EN    = 'd0;
			DAT_SAMPL_EN = 'd1;
			STR_CHK_EN = 'd1;
			COUNTER_EN = 'd1;
		end
		
		DATA:
		begin
		    Data_VALID_REGISTER = 'd0;
			STP_CHK_EN = 'd0;
			STR_CHK_EN = 'd0;
			PRT_CHK_EN = 'd0;
			DSER_EN    = 'd1;
			DAT_SAMPL_EN = 'd1;
			COUNTER_EN = 'd1;
		end
		
		
		PARITY:
		begin
		    Data_VALID_REGISTER = 'd0;
			STP_CHK_EN = 'd0;
			STR_CHK_EN = 'd0;
			DSER_EN    = 'd0;
			DAT_SAMPL_EN = 'd1;
			PRT_CHK_EN = (PAR_EN ? 1'b1 : 1'b0) ;
			COUNTER_EN = 'd1;
		end
			

		STOP:
		begin
		    Data_VALID_REGISTER = 'd0;
			STR_CHK_EN = 'd0;
			DSER_EN    = 'd0;
			DAT_SAMPL_EN = 'd1;
			PRT_CHK_EN = 'd0;
			STP_CHK_EN = 'd1;
			COUNTER_EN = 'd1;
		end
		
		VALIDATE:
		begin
		    Data_VALID_REGISTER =  !( STP_ERR || PAR_ERR);
			STR_CHK_EN = 'd0;
			DSER_EN    = 'd0;
			DAT_SAMPL_EN = 'd0;
			PRT_CHK_EN = 'd0;
			STP_CHK_EN = 'd0;
			COUNTER_EN = 'd0;
			if(S_DATA == 'd0) //consequent frame
			begin
			    STR_CHK_EN = 'd1;
			    DAT_SAMPL_EN = 'd1;
				COUNTER_EN = 'd1;
			end
		end
		
		default:
		begin
		    Data_VALID_REGISTER =  'd0;
			STR_CHK_EN = 'd0;
			DSER_EN    = 'd0;
			DAT_SAMPL_EN = 'd0;
			PRT_CHK_EN = 'd0;
			STP_CHK_EN = 'd0;
			COUNTER_EN = 'd0;
		end
	endcase
end





///////////////// Next State Logic  /////////////////////////
always@(*)
begin
    case(curr_state)
	    
		IDLE:
		begin
		    if(S_DATA == 'b0)
			    nxt_state = START ;
			else
			    nxt_state = IDLE;
		end
		
		START:
		begin
		
		    if(BIT_AVAILABLE)
			begin
			
		        if(START_GLSH)
			        nxt_state = IDLE;
					
			    else
				begin
				    nxt_state = DATA;
				end
			end
			
			else 
			    nxt_state = START ;
		

		end
		
		DATA:
		begin
		    if(BIT_CNT == 'd9) //8 bits recieved (start 8bits)
			begin
			    if(!PAR_EN)
			        nxt_state = STOP;
				else
				    nxt_state = PARITY;
			end
			else
			    nxt_state = DATA;
		end
		
		PARITY:
		begin
		
			if(BIT_CNT == 'd10) //9 bits recieved (start 8bits parity)
				nxt_state = STOP;
		end
		

		STOP:
		begin
		    if(BIT_AVAILABLE)
			begin
		        if(STP_ERR)
			        nxt_state = IDLE;
			    else
			        nxt_state = VALIDATE ;
			end
			
			else 
			    nxt_state = STOP ;
		end
		
		
		VALIDATE:
		begin
		    if(!S_DATA)
			        nxt_state = START;
			else
			        nxt_state = IDLE;
		end
		
		default:
            nxt_state = IDLE;
	endcase
end


///////////////// Output register /////////////////////////
always@(posedge CLK or negedge RST)
begin
    if(!RST)
	    DATA_VALID<= 'd0;
	else
	    DATA_VALID<= Data_VALID_REGISTER;
end

endmodule