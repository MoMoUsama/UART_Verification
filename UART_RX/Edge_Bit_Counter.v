module Edge_Bit_Counter (
    input CLK,RST,
	input EN,
	input [5:0] PRESCALE,
	
	output reg [5:0] Edge_Cnt, // 4 8 16 32  
	output reg [3:0] Bit_Cnt   // MAX 11 BITS (start parity 8bits stop)
);

always@(posedge CLK or negedge RST)
begin
    if(!RST)
	begin
	    Edge_Cnt<= 'd0;
		Bit_Cnt <= 'd0;
	end
	
	else
	begin
		if(EN)
		begin
		
			if(PRESCALE == (Edge_Cnt + 'd1) )
			begin
				Edge_Cnt<= 'd0;
				Bit_Cnt <= Bit_Cnt + 'd1;
			end
			
			else
				Edge_Cnt<= Edge_Cnt + 'd1;
		end
		
		else
		begin
			Edge_Cnt<= 'd0;
			Bit_Cnt <= 'd0;		
		end
	end
	
end
endmodule