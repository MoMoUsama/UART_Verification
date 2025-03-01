module Parity_Calc #(parameter Width=8)(

input  [Width-1:0] PARALLEL_DATA,
input  Parity_Type,RST,CLK,DATA_VALID,BUSY,
output reg Parity_bit
);


//////////////// check no. of ones in the data //////////////////////////
wire odd_even_ones ;
assign odd_ones = ( ^PARALLEL_DATA ) ;


reg [Width-1:0] data ;


//////////////// seq for data //////////////////////////
always@(posedge CLK or negedge RST)
begin

    if(!RST)
	    data<= 'd0;
	else if( !BUSY && DATA_VALID)
	    data<= PARALLEL_DATA;
end


//////////////// evaluate the parity bit //////////////////////////
always@(*)
begin
      
	if(Parity_Type)   //odd parity
	begin
	    if(odd_ones)
            Parity_bit=1'b0;
        else
            Parity_bit=1'b1;		
	end
	
	else  //for even parity
	begin
	
	    if(odd_ones)
            Parity_bit=1'b1;
        else
            Parity_bit=1'b0;
	end
	
end
endmodule
