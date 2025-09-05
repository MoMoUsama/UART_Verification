class uart_wb_driver extends uvm_driver #(wb_seq_item);

  virtual wb_intf vif; // virtual interface to DUT
  `uvm_component_utils(uart_wb_driver)

  function new(string name="uart_wb_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    if(!uvm_config_db#(virtual wb_intf)::get(this, "", "WB", vif))
      `uvm_fatal("WB_Driver cannot founf vif", "WB Interface not found in uvm_config_db")
  endfunction
  
  task run_phase(uvm_phase phase);
    wb_seq_item tr;
	
    forever begin
	    seq_item_port.get_next_item(tr);
		if(tr.rst) begin
			vif.WBRST<= 1;
			repeat(5) @(posedge vif.WBCLK);
			vif.WBRST<= 0;
			repeat(5) @(posedge vif.WBCLK);
		end
		
		else begin
			@(negedge vif.WBCLK);
			vif.WB_ADDR      <= tr.addr;
			vif.WB_DAT_I     <= tr.data;
			vif.WB_WE        <= tr.we;
			vif.WB_STB  <= 1;
			vif.WB_CYC  <= 1;
			vif.WB_SEL  <= tr.sel;
			
			@(posedge vif.WB_ACK);
			tr.ack = 1'b1;
			if(!tr.we) begin
				tr.data = vif.WB_DAT_O;
				$display("@%0t  the Driver read data is %0h", $time/1ns, tr.data);
			end
			@(negedge vif.WBCLK);
			
			// clear handshake
			vif.WB_STB <= 0;
			vif.WB_CYC <= 0;
			vif.WB_WE  <= 0;
			@(negedge vif.WBCLK);
	    end 

      seq_item_port.item_done();
	  $display("@%0t Item: \n %s drived SUCCESFULLY", $time/1ns, tr.sprint());
    end
  endtask
endclass
