/*
4 types of sequences considered:
	1- random Sequence
	2- RESET Sequence
	3- Read Sequence
	4- Write Sequence
*/

class Sequence extends uvm_sequence#(Transaction);
    `uvm_object_utils(Sequence)
	
    Transaction item;
    int num_transactions;
	
    virtual task do_item();
        item=Transaction::type_id::create("item");
        start_item(item);  //handshaking with driver (blocking statment)
        assert (item.randomize())
        else 
            $error("randomiztion failed");
        finish_item(item); //send the item to the driver (blocking statment))
    endtask
    
	// it is the run_phase of the uvm_object
    virtual task body();
        repeat(num_transactions)
            do_item();
    endtask
	
    function new (string name="Sequence");
        super.new(name);
    endfunction
endclass:Sequence


class Reset_Sequence extends Sequence;
    `uvm_object_utils(Reset_Sequence)
	
    Transaction item1;
    task do_item();
        item1=Transaction::type_id::create("item1");
        start_item(item1);
        assert (item1.randomize() with {rst==0; write==0;} )
        else 
            $error("randomiztion failed");
        finish_item(item1);
    endtask
    
    virtual task body();
        repeat(num_transactions)
            do_item();
    endtask
    function new (string name="Reset_Sequence");
        super.new(name);
    endfunction
endclass:Reset_Sequence


class Write_Sequence extends Sequence;
    `uvm_object_utils(Write_Sequence)
    Transaction item;
	
    task do_item();
        item=Transaction::type_id::create("item");
        start_item(item);
        assert (item.randomize()with{rst==1; write==1; en==1;})
        else 
            $error("randomiztion failed");
        finish_item(item);
    endtask
    virtual task body();
        repeat(num_transactions)
            do_item();
    endtask
    function new (string name="Write_Sequence");
        super.new(name);
    endfunction
endclass:Write_Sequence


class Read_Sequence extends Sequence;
    `uvm_object_utils(Read_Sequence)
     Transaction item;
    task do_item();
        item=Transaction::type_id::create("item");
        start_item(item);
        assert (item.randomize()with{rst==1; write==0; en==1;})
        else 
            $error("randomiztion failed");
        finish_item(item);
    endtask
    virtual task body();
        repeat(num_transactions)
            do_item();
    endtask
	
    function new (string name="Read_Sequence");
        super.new(name);
    endfunction
endclass:Read_Sequence