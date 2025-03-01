class Subscriber extends uvm_subscriber;
    `uvm_component_utils(Subscriber)
	
    TX_Transaction tx_item;
	RX_Transaction rx_item;
    uvm_analysis_imp#(TX_Transaction,Subscriber) tx_sub_imp;
	uvm_analysis_imp#(RX_Transaction,Subscriber) rx_sub_imp;
	
    covergroup tx_cg;
	
        reset: coverpoint tx_item.rst{
            bins low={0};
            bins high={1};
            bins lowtohigh = (0=>1);
			bins hightolow = (1=>0);
        }
		
        par_en: coverpoint tx_item.par_en{
            bins low={0};
            bins high={1};
            
        }
        par_type: coverpoint tx_item.par_type{
            bins even={0};
            bins odd={1};
        }

        cross1: cross par_en,par_type;  //cover combination of  each bin in Data_in with each bin in Address (2*2=4 bins) (the max bins is 64)
    endgroup
	
	
    covergroup rx_cg;
	
        reset: coverpoint rx_item.rst{
            bins low={0};
            bins high={1};
            bins lowtohigh = (0=>1);
			bins hightolow = (1=>0);
        }
		
        par_en: coverpoint rx_item.par_en{
            bins low={0};
            bins high={1};
            
        }
		
        par_type: coverpoint rx_item.par_type{
            bins even={0};
            bins odd={1};
        } 
		
        prescale: coverpoint rx_item.prescale{
            bins four={4};
            bins eight={8};
			bins sixteen={16};
			bins thirty_two={32};
        }
		
        Valid_checking: coverpoint rx_item.RX_out_valid{
            bins valid_packet={1};
            bins invalid_packet={0};
        }

        cross1: cross par_en,par_type;  //cover combination of  each bin in par_en with each bin in par_type (2*2=4 bins) (the max bins is 64)
    endgroup
	
    function new (string name="Subscriber", uvm_component parent =null);
        super.new(name,parent);
        tx_cg=new(); //not created in the build_phase
		rx_cg=new();
    endfunction
	
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tx_sub_imp=new("tx_sub_imp",this);
		rx_sub_imp=new("rx_sub_imp",this);
		tx_item = TX_Transaction::type_id::create("tx_item",this);
		rx_item = RX_Transaction::type_id::create("rx_item",this);
    endfunction
	
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
	
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
	
    virtual function void write_tx(TX_Transaction t);
        tx_item.copy(t);
        tx_cg.sample(); //sample when a new transaction arrives
    endfunction
	
    virtual function void write_rx(RX_Transaction t);
        rx_item.copy(t);
        rx_cg.sample(); //sample when a new transaction arrives
    endfunction
	
    function void report_phase (uvm_phase phase);
    `uvm_info("Subscriber", $sformatf("TX coverage =%0d", tx_cg.get_coverage), UVM_NONE);
	`uvm_info("Subscriber", $sformatf("RX coverage =%0d", rx_cg.get_coverage), UVM_NONE);
    endfunction
	
endclass:Subscriber

