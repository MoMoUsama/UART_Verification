class uart_reg_backdoor_policy extends uvm_reg_backdoor;
  `uvm_object_utils(uart_reg_backdoor_policy)

  function new(string name="uart_reg_backdoor_policy");
    super.new(name);
  endfunction
  
	task get_path(uvm_reg_item rw, ref string path);
	  uvm_reg r;
	  uvm_hdl_path_concat paths[$];

	  if ($cast(r, rw.element)) begin
		r.get_full_hdl_path(paths);
		if (paths.size() > 0) begin
			path = {path, paths[0].slices[0].path};
		end
	  end

	  `uvm_info("DEBUG",
				$sformatf("HDL path for %s: %s", r.get_name(), path),
				UVM_MEDIUM)
	endtask
	
  // Override WRITE to use uvm_hdl_force instead of deposit
  virtual task write(uvm_reg_item rw);
    string path="";	
	
	
	get_path(rw, path);
	`uvm_info("BKDR", $sformatf("Trying to backdoor access: %s", path), UVM_MEDIUM)
    if (path == "") begin
      `uvm_error("BACKDOOR", {"No HDL path defined for: ", rw.element.get_name()})
      return;
    end

    if (!uvm_hdl_force(path, rw.value[0])) begin
      `uvm_error("BACKDOOR", $sformatf("uvm_hdl_force failed to write %0h on %s ", rw.value[0], path))
    end
    // release right after force so it "sticks" as if deposited
    void'(uvm_hdl_release(path));
  endtask

  // Override READ as well (if needed)
  virtual task read(uvm_reg_item rw);
    string path="";
    uvm_reg_data_t val;
	get_path(rw, path);
	`uvm_info("BKDR", $sformatf("Trying to backdoor access: %s", path), UVM_MEDIUM)
    if (path == "") begin
      `uvm_error("BACKDOOR", {"No HDL path defined for: ", rw.element.get_name()})
      return;
	end
	
    if (!uvm_hdl_read(path, val)) begin
      `uvm_error("BACKDOOR", $sformatf("uvm_hdl_read failed on %s", path))
    end else begin
      rw.value[0] = val;
    end
  endtask
endclass
