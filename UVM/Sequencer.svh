//parameterized sequencer class that can be configured for either TX or RX transactions
class Sequencer #(type SEQ_ITEM = uvm_sequence_item) extends uvm_sequencer#(SEQ_ITEM);

    //factory macros need the full parameterized type
    `uvm_component_param_utils(Sequencer#(SEQ_ITEM))
	
    function new (string name="Sequencer", uvm_component parent =null);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
	
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
	
endclass:Sequencer
