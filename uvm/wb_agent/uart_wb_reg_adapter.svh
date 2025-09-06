class uart_wb_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(uart_wb_reg_adapter)
	uart_reg_block    ral_model;  // env will set it  
	
    function new(string name="uart_wb_reg_adapter");
    super.new(name);
    provides_responses = 0; // no response needed from the driver
	supports_byte_enable = 1;
  endfunction
  
  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
  
		wb_seq_item wb_item;
		bit dlab = ral_model.LCR.get_mirrored_value()[7];
		
		if($cast(wb_item, bus_item)) begin
			`uvm_info("Adapter.bus2reg", $sformatf("Recieved ACK from the Monitor wb_item.ack = %0b", wb_item.ack), UVM_MEDIUM)
			rw.kind = (wb_item.we)? UVM_WRITE : UVM_READ;
			rw.addr = wb_item.addr;
			rw.data = wb_item.data;
			rw.status = (wb_item.ack)? UVM_IS_OK : UVM_NOT_OK;
			
			if(dlab && rw.addr == 'd0  ) begin //switch to DLL
				rw.addr = 'hA;
			end
			else if(dlab && rw.addr == 'd1 ) begin //switch ro DLM
				rw.addr = 'hB;
			end

		  `uvm_info("Adapter.bus2reg()",
					$sformatf("New uvm_reg_bus_op: kind=%s addr=0x%0h data=0x%0h dlab = %0b  status=%0s",
							  (rw.kind == UVM_WRITE) ? "WRITE" : "READ",
							  rw.addr, rw.data, dlab, (rw.status==UVM_IS_OK)? "OK" : "NOT OK"),
					UVM_MEDIUM)
		end
		
		else begin
			`uvm_fatal("WB_ADAPTER", "bus_item is not of type wb_seq_item")
		end
  endfunction
  
  // Convert from register-level operation to bus-level item
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    wb_seq_item wb_item = wb_seq_item::type_id::create("wb_item");
	bit dlab = ral_model.LCR.get_mirrored_value()[7];
	
    wb_item.rst=0;
    wb_item.addr = rw.addr;
    wb_item.we   = (rw.kind == UVM_WRITE);
    wb_item.data = rw.data;
	wb_item.sel = 4'b0001;

			if(dlab && rw.addr == 'hA  ) begin //switch to DLL
				wb_item.addr = 'd0;
				wb_item.lcr = 8'h83;
			end
			else if(dlab && rw.addr == 'hB  ) begin //switch ro DLM
				wb_item.addr = 'd1;
				wb_item.lcr = 8'h83;
			end
			
  // Print the received reg_bus_op
  `uvm_info("Adapter.reg2bus",
            $sformatf("Received uvm_reg_bus_op: kind=%s addr=0x%0h data=0x%0h Status=%0s",
                      (rw.kind == UVM_WRITE) ? "WRITE" : "READ",
                      rw.addr, rw.data, (rw.status == UVM_IS_OK)? "OK" : "NOT OK"),
            UVM_MEDIUM)
			
			
    return wb_item;
  endfunction
  
endclass
