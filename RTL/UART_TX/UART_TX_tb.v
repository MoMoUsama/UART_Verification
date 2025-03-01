`timescale 1us/1ns

module UART_TX_tb 
#(parameter CLOCK_PERIOD=8.6805 , Width=8)
();



/////////////////////////////////////////////////
////////////////////// signals //////////////////
/////////////////////////////////////////////////

reg CLK_tb,RST_tb;
reg [Width-1:0] PARALLEL_DATA_tb;
reg PARITY_TYPE_tb,PARITY_EN_tb;
reg DATA_VALID_tb;
wire SER_OUT_tb;
wire BUSY_tb;



///////////////////////////////////////////////////
///////////////// instantiation ///////////////////
///////////////////////////////////////////////////

UART_TX DUT (
                .CLK_TOP(CLK_tb),
				.RST_TOP(RST_tb),
				.PARALLEL_DATA_TOP(PARALLEL_DATA_tb),
				.PARITY_EN_TOP(PARITY_EN_tb),
				.PARITY_TYPE_TOP(PARITY_TYPE_tb),
				.DATA_VALID_TOP(DATA_VALID_tb),
				.SER_OUT_TOP(SER_OUT_tb),
				.BUSY_TOP(BUSY_tb)
				
            );
			
			
///////////////////////////////////////////////////
////////////////// Clock Generator  ///////////////
///////////////////////////////////////////////////

always #(CLOCK_PERIOD/2)  CLK_tb = ~(CLK_tb) ;

///////////////////////////////////////////////////
///////////////// INITIAL BLOCK //////////////////
//////////////////////////////////////////////////

initial 
    begin
	
	    initialize();
		reset();
		
     ///////////////// Test 1 (check DATA_VALID , data with parity & serialization ) ////////////////////////
		
		PARALLEL_DATA_tb = 8'hFF;
		PARITY_EN_tb=1'b1;
		PARITY_TYPE_tb=1'b0;  //even parity
		DATA_VALID_tb=1'b1;
		
		//# (CLOCK_PERIOD)
		//DATA_VALID_tb=1'b0;
		
		check(PARALLEL_DATA_tb,PARITY_EN_tb,PARITY_TYPE_tb,3'd0);
		
	 ///////////////// Test 2 (check DATA_VALID , data with parity & serialization ) ////////////////////////

		PARALLEL_DATA_tb = 8'hFF;
		PARITY_EN_tb=1'b0;
		PARITY_TYPE_tb=1'b0;  //even parity
		DATA_VALID_tb=1'b1;
		
		# (CLOCK_PERIOD)
		DATA_VALID_tb=1'b0;
		
		check(PARALLEL_DATA_tb,PARITY_EN_tb,PARITY_TYPE_tb,3'd1);
		
	 ///////////////// Test 3 (check DATA_VALID , data with parity & serialization ) ////////////////////////

		PARALLEL_DATA_tb = 8'h7F;
		PARITY_EN_tb=1'b0;
		PARITY_TYPE_tb=1'b0;  //even parity
		DATA_VALID_tb=1'b1;
		
		# (CLOCK_PERIOD)
		DATA_VALID_tb=1'b0;
		
		check(PARALLEL_DATA_tb,PARITY_EN_tb,PARITY_TYPE_tb,3'd2);
		$stop ;
	
	end


    ///////////////////////////////////////////////////
   ///////////////////// Tasks //////////////////////
   //////////////////////////////////////////////////


/////////////// Signals Initialization //////////////////

task initialize ;
 begin
  CLK_tb  = 'b0;
  RST_tb  = 'b1;
  PARALLEL_DATA_tb = 'd0;
  PARITY_TYPE_tb  = 'b0;
  PARITY_EN_tb = 'b0;
  DATA_VALID_tb = 'b0;
 end  
endtask


///////////////////////// RESET /////////////////////////

task reset ;
 begin
  #(CLOCK_PERIOD)  
  RST_tb  = 'b0;
  #(CLOCK_PERIOD)
  RST_tb  = 'b1;
 end
endtask

task check ;
 input [Width-1:0] data;
 input par_en,par_type;
 input [2:0] test_num;
 
 reg [10:0] gener_out,expec_out;
 reg par_bit;
integer timeout,i;

begin
    timeout = 30; // Set a timeout value (adjust as needed)
    while ( (!BUSY_tb && timeout > 0)) begin
        #(CLOCK_PERIOD);
        timeout = timeout - 1;
    end

    if (timeout == 0) begin
        $display("Timeout waiting for BUSY_tb to change test %d", test_num);
		$display("BUSY_tb is %d", BUSY_tb);
		$stop;
    end

 
	for(i=0;i<11;i=i+'d1)
	begin
	    @(negedge CLK_tb) gener_out[i]=SER_OUT_tb;
	end
	
	if(par_en)
	begin
	    if(par_type) //even
		    par_bit= !(^data);
		else
		    par_bit = ^data;

	end
	else
	    par_bit = 1'b1;
		
	if(par_en)
	    expec_out = {1'b1 , par_bit , data , 1'b0};
	else
	    expec_out = {2'b11,data,1'b0};
		
	if(expec_out == gener_out)
	    $display("test %d passed",test_num);
	else
	    $display("test %d failed recieved %b",test_num,expec_out);
	
	
	
 end
endtask

endmodule