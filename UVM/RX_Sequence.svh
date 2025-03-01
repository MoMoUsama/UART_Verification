class RX_Sequence extends uvm_sequence #(RX_Transaction);
  `uvm_object_utils(RX_Sequence)
  
  function new(string name = "RX_Sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    tr_generation(1,1); //rst transaction
	tr_generation(10,0); //normal transaction
	tr_generation(1,1); //rst again
  endtask
	
  task tr_generation;
		input int num_of_tr;
		input bit rst;

		repeat(num_of_tr) begin 
		  RX_Transaction rx_item = RX_Transaction::type_id::create("rx_item");
		  start_item(rx_item);
		  
		  if(!rx_item.randomize()) 
			`uvm_error("TX_SEQ", "Randomization failed")
			
		  rx_item.rst=rst;
		  
		$display("Transaction_ID=%0d Generated Successfully in RX_Sequence",rx_item.transaction_id);  
		rx_item.print_tr("RX_Sequence");
		
		finish_item(rx_item); //send to drv
		end
  endtask
endclass