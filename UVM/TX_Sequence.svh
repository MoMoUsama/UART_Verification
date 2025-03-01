class TX_Sequence extends uvm_sequence #(TX_Transaction);
  `uvm_object_utils(TX_Sequence)
  
  function new(string name = "TX_Sequence");
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
		  TX_Transaction tx_item = TX_Transaction::type_id::create("tx_item");
		  start_item(tx_item);
		  
		  if(!tx_item.randomize()) 
			`uvm_error("TX_SEQ", "Randomization failed")
			
		  tx_item.data_valid=1'b1;
		  tx_item.rst=rst;
		  
		$display("Transaction_ID=%0d Generated Successfully in TX_Sequence",tx_item.transaction_id);  
		tx_item.print_tr("TX_Sequence");
		
		finish_item(tx_item); //send to drv
		end
  endtask
endclass