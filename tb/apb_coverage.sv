class apb_coverage extends uvm_subscriber #(apb_transaction);
	`uvm_component_utils(apb_coverage)

	apb_transaction item;

	covergroup apb_cov;
		option.auto_bin_max = 2**16;
		addr: coverpoint item.paddr ;
		wdata: coverpoint item.pwdata {
			bins low = {[0:(2**5)-1]};
			bins mid = {[2**5:(2**10)-1]};
			bins high = {[2**10:$]};
		}
		rdata: coverpoint item.prdata {
			bins low = {[0:(2**5)-1]};
			bins mid = {[2**5:(2**10)-1]};
			bins high = {[2**10:$]};
		}
		opcode: coverpoint item.pwrite;
	endgroup

	function new (string name="apb_coverage", uvm_component parent);
		super.new(name,parent);
		apb_cov = new();
	endfunction

	virtual function void write (apb_transaction t);	// 't' is from the base class (subscriber) - otherwise it will give a warning
		item = apb_transaction::type_id::create("item");

		item.paddr = t.paddr;
		item.pwdata = t.pwdata;
		item.prdata = t.prdata;
		item.pwrite = t.pwrite;

		apb_cov.sample();

	endfunction

endclass
