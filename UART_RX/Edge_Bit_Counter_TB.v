module Edge_Bit_Cnt_TB ();

    reg CLK_tb,CLK_MASTER,RST_tb;
	reg EN_tb;
	reg [5:0] PRESCALE_tb;
	
	wire [5:0] Edge_Cnt_tb; // 4 8 16 32  
	wire [3:0] Bit_Cnt_tb;
	
	Edge_Bit_Counter DUT(
    .CLK(CLK_tb),
	.RST(RST_tb),
	.EN(EN_tb),
	.PRESCALE(PRESCALE_tb),
	.Edge_Cnt(Edge_Cnt_tb), // 4 8 16 32  
	.Bit_Cnt(Bit_Cnt_tb)
);
	
	
    always #5  CLK_tb = ~(CLK_tb) ; 
	always #(5*4)  CLK_MASTER = ~(CLK_MASTER) ; 
	
    initial
	begin
	
	    initialize();
		reset();
		
		#(5*4)
		EN_tb = 1'b1;
		#500
		$stop;
	end
	
	
	
task initialize ;
 begin
  CLK_tb  = 'b0;
  CLK_MASTER = 'b0;
  RST_tb  = 'b0;
  PRESCALE_tb = 'd4;
  EN_tb  = 'b0;
 end  
endtask


///////////////////////// RESET /////////////////////////

task reset ;
 begin
  RST_tb  = 'b1; 
   #5 
  RST_tb  = 'b0;
  #5
  RST_tb  = 'b1;
 end
endtask

endmodule