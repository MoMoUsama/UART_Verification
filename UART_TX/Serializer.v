module Serializer #(parameter Width=8)(

input  [Width-1:0] PARALLEL_DATA,
input  SER_EN,
input  DATA_VALID,
input  CLK,RST,BUSY,
output wire SER_DONE,
output wire SER_OUT
);


/////////////// signals //////////////////
reg   [Width-1:0] data;
reg   [2:0]counter;


/////////////// seq always for data  /////////////////////
always@(posedge CLK or negedge RST)
    begin
	
	    if(!RST) //important for synthesis 
		begin
		    data<= 'd0;
		end
			
		else
		begin
		
			if (DATA_VALID && !BUSY)
			begin
			    data<=PARALLEL_DATA;
			end
			
			else if(SER_EN) //data transmission 
			begin
			    data<={1'b0,data[7:1]}; //shift register
			end
			
	    end	
		
	end
	
	
//////////////// counter /////////////////////////////////
always@(posedge CLK or negedge RST)
    begin
	
	    if(!RST)
		    counter<= 'd0;
		else
		begin
		
		    if(SER_EN)
			begin
			    counter<=counter+1'b1;
			end
			
		    else
		        counter<= 'd0;
		end
	end

	
//////////////////// combinational code //////////////////////////////////
assign SER_DONE = (counter == 3'd7);

assign SER_OUT = data[0];

endmodule
